import 'dart:io';

import 'identity.dart';
import 'plan.dart';
import 'resolved_packages.dart';
import 'state.dart';

/// Raised for problems the developer can fix (invalid input, wrong state).
class InitException implements Exception {
  InitException(this.message, {this.exitCode = 1});

  final String message;
  final int exitCode;

  @override
  String toString() => message;
}

/// Exit code used when the repository is already initialized.
const alreadyInitializedExitCode = 3;

class InitResult {
  InitResult({
    required this.files,
    required this.previous,
    required this.identity,
  });

  final List<PlannedFile> files;
  final ProjectIdentity previous;
  final ProjectIdentity identity;
}

/// Turns a Flutter Base checkout at [root] into a project.
class ProjectInitializer {
  ProjectInitializer(this.root, {this.formatGeneratedCode = true});

  final Directory root;

  /// Runs `dart format` on the generated localization files after writing
  /// them, so a longer app name does not leave them unformatted.
  final bool formatGeneratedCode;

  ProjectState readState() => ProjectState.read(root);

  IdentityValidator validator() =>
      IdentityValidator(reservedPackageNames: reservedPackageNames());

  /// Names the application package must not take: the other workspace
  /// packages and every package in the dependency graph, direct or indirect.
  Set<String> reservedPackageNames() {
    final names = <String>{
      'flutter',
      'flutter_test',
      'flutter_driver',
      'test',
      ...resolvedPackageNames,
    };
    // After `melos bootstrap`, the lock also covers dependencies added since
    // resolvedPackageNames was last updated.
    final lock = File('${root.path}/pubspec.lock');
    if (lock.existsSync()) {
      names.addAll(lockedPackageNames(lock.readAsStringSync()));
    }
    final pubspecs = [
      File('${root.path}/pubspec.yaml'),
      ...['modules', 'tool']
          .map((d) => Directory('${root.path}/$d'))
          .where((d) => d.existsSync())
          .expand((d) => d.listSync())
          .whereType<Directory>()
          .map((d) => File('${d.path}/pubspec.yaml')),
      File('${root.path}/app/pubspec.yaml'),
    ].where((f) => f.existsSync());
    const dependencySections = {
      'dependencies',
      'dev_dependencies',
      'dependency_overrides',
    };
    final topLevelKey = RegExp(r'^([a-z_]+):');
    final dependencyKey = RegExp(r'^  ([a-z][a-z0-9_]*):');
    for (final pubspec in pubspecs) {
      final isApp = pubspec.parent.path == Directory('${root.path}/app').path;
      String? section;
      for (final line in pubspec.readAsLinesSync()) {
        final topLevel = topLevelKey.firstMatch(line);
        if (topLevel != null) {
          section = topLevel.group(1);
          if (section == 'name' && !isApp) names.add(line.substring(5).trim());
          continue;
        }
        final dependency = dependencyKey.firstMatch(line);
        if (dependency != null && dependencySections.contains(section)) {
          names.add(dependency.group(1)!);
        }
      }
    }
    return names;
  }

  /// Validates [target], computes the plan and, unless [dryRun], applies it.
  InitResult run(ProjectIdentity target, {bool dryRun = false}) {
    final state = readState();
    if (state.state == RepositoryState.initialized) {
      throw InitException(
        'This repository is already initialized as "${state.identity.displayName}" '
        '(${state.identity.packageName}, Android ${state.identity.androidApplicationId}, '
        'iOS ${state.identity.iosBundleId}). The initializer only runs once on a '
        'template; change identifiers by hand from here, or start again from a '
        'fresh copy of the Flutter Base.',
        exitCode: alreadyInitializedExitCode,
      );
    }

    final errors = validator().validate(target);
    if (errors.isNotEmpty) {
      throw InitException(
        'Invalid project identity:\n${errors.map((e) => '  - $e').join('\n')}',
      );
    }

    final files = InitPlanner(
      root,
      current: state.identity,
      target: target,
    ).plan();
    if (!dryRun) {
      _apply(files);
      if (formatGeneratedCode) _formatGenerated(files);
    }
    return InitResult(files: files, previous: state.identity, identity: target);
  }

  /// Writes every planned file. If any write fails, all files are restored.
  void _apply(List<PlannedFile> files) {
    final originals = <String, String?>{};
    for (final file in files) {
      for (final path in [file.path, if (file.isMove) file.from!]) {
        final existing = _file(path);
        originals.putIfAbsent(
          path,
          () => existing.existsSync() ? existing.readAsStringSync() : null,
        );
      }
    }
    try {
      for (final file in files) {
        final target = _file(file.path);
        target.parent.createSync(recursive: true);
        target.writeAsStringSync(file.content);
      }
      for (final file in files.where((f) => f.isMove)) {
        _file(file.from!).deleteSync();
        _deleteEmptyParents(_file(file.from!).parent);
      }
    } catch (_) {
      for (final entry in originals.entries) {
        final file = _file(entry.key);
        if (entry.value == null) {
          if (file.existsSync()) file.deleteSync();
        } else {
          file.parent.createSync(recursive: true);
          file.writeAsStringSync(entry.value!);
        }
      }
      rethrow;
    }
  }

  void _formatGenerated(List<PlannedFile> files) {
    final generated = files
        .map((f) => f.path)
        .where((p) => p.contains('/generated/') && p.endsWith('.dart'))
        .map((p) => _file(p).path)
        .toList();
    if (generated.isEmpty) return;
    try {
      Process.runSync(Platform.resolvedExecutable, ['format', ...generated]);
    } on ProcessException {
      // Formatting is cosmetic; `melos run format` reports anything left over.
    }
  }

  /// Removes directories left empty by a move, stopping at the Kotlin root.
  void _deleteEmptyParents(Directory dir) {
    var current = dir;
    while (!current.path.endsWith('kotlin') &&
        current.existsSync() &&
        current.listSync().isEmpty) {
      current.deleteSync();
      current = current.parent;
    }
  }

  File _file(String relativePath) => File('${root.path}/$relativePath');
}
