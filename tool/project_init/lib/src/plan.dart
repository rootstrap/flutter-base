import 'dart:convert';
import 'dart:io';

import 'identity.dart';
import 'state.dart';

/// Thrown when a file does not contain the value the initializer expects.
/// The repository has drifted from what the initializer knows how to change,
/// so nothing is written.
class TemplateDriftException implements Exception {
  TemplateDriftException(this.path, this.expected);

  final String path;
  final String expected;

  @override
  String toString() =>
      'Expected $path to contain $expected. The repository no longer matches '
      'what the initializer knows how to change, so nothing was modified. '
      'Update tool/project_init/lib/src/plan.dart to match the template.';
}

/// One file the initializer writes. [from] is set when the file moves.
class PlannedFile {
  PlannedFile({required this.path, required this.content, this.from});

  /// Path relative to the repository root, with `/` separators.
  final String path;
  final String content;
  final String? from;

  bool get isMove => from != null;
}

/// Computes every change needed to turn [current] into [target], without
/// touching the file system. The result is only written if the whole plan
/// could be computed.
class InitPlanner {
  InitPlanner(this.root, {required this.current, required this.target});

  final Directory root;
  final ProjectIdentity current;
  final ProjectIdentity target;

  final _changes = <String, PlannedFile>{};

  static const _appDir = 'app';
  static const _dartSourceDirs = [
    'lib',
    'test',
    'integration_test',
    'test_driver',
  ];

  List<PlannedFile> plan() {
    _workspacePubspec();
    _appPackage();
    _android();
    _ios();
    _web();
    _localizations();
    _sonar();
    _stateFile();
    return _changes.values.toList();
  }

  // --- Dart / workspace ----------------------------------------------------

  void _workspacePubspec() {
    _edit(
      'pubspec.yaml',
      (content) => _replacePattern(
        'pubspec.yaml',
        content,
        RegExp(r'^name: .+$', multiLine: true),
        'name: ${target.packageName}_workspace',
        'a top-level "name:" field',
      ),
    );
  }

  void _appPackage() {
    _edit(
      '$_appDir/pubspec.yaml',
      (content) => _replaceExact(
        '$_appDir/pubspec.yaml',
        content,
        'name: ${current.packageName}\n',
        'name: ${target.packageName}\n',
      ),
    );

    final oldImport = 'package:${current.packageName}/';
    final newImport = 'package:${target.packageName}/';
    var rewritten = 0;
    for (final dir in _dartSourceDirs) {
      for (final file in _dartFiles('$_appDir/$dir')) {
        final content = _read(file);
        if (!content.contains(oldImport)) continue;
        _changes[file] = PlannedFile(
          path: file,
          content: content.replaceAll(oldImport, newImport),
        );
        rewritten++;
      }
    }
    if (rewritten == 0 && oldImport != newImport) {
      throw TemplateDriftException('$_appDir/lib', 'imports of "$oldImport"');
    }
  }

  // --- Android -------------------------------------------------------------

  void _android() {
    const properties = '$_appDir/android/build.properties';
    _edit(properties, (content) {
      var result = _replaceProperty(
        properties,
        content,
        'flutter.applicationId',
        current.androidApplicationId,
        target.androidApplicationId,
      );
      result = _replaceProperty(
        properties,
        result,
        'flutter.namespace',
        current.androidNamespace,
        target.androidNamespace,
      );
      return _replaceProperty(
        properties,
        result,
        'flutter.appName',
        _propertyValue(current.displayName),
        _propertyValue(target.displayName),
      );
    });

    if (current.androidNamespace == target.androidNamespace) return;
    const sourceRoot = '$_appDir/android/app/src/main/kotlin';
    final oldDir =
        '$sourceRoot/${current.androidNamespace.replaceAll('.', '/')}';
    final newDir =
        '$sourceRoot/${target.androidNamespace.replaceAll('.', '/')}';
    final sources = _files(
      oldDir,
      recursive: false,
    ).where((f) => f.endsWith('.kt') || f.endsWith('.java')).toList();
    if (sources.isEmpty) {
      throw TemplateDriftException(
        oldDir,
        'the Kotlin sources of package ${current.androidNamespace}',
      );
    }
    for (final source in sources) {
      final name = source.substring(oldDir.length + 1);
      _changes['$newDir/$name'] = PlannedFile(
        path: '$newDir/$name',
        from: source,
        content: _replaceExact(
          source,
          _read(source),
          'package ${current.androidNamespace}\n',
          'package ${target.androidNamespace}\n',
        ),
      );
    }
  }

  // --- iOS -----------------------------------------------------------------

  void _ios() {
    const identity = '$_appDir/ios/Flutter/AppIdentity.xcconfig';
    _edit(identity, (content) {
      final result = _replaceExact(
        identity,
        content,
        'APP_BUNDLE_ID=${current.iosBundleId}\n',
        'APP_BUNDLE_ID=${target.iosBundleId}\n',
      );
      return _replaceExact(
        identity,
        result,
        'APP_DISPLAY_NAME=${current.displayName}\n',
        'APP_DISPLAY_NAME=${target.displayName}\n',
      );
    });
  }

  // --- Web -----------------------------------------------------------------

  void _web() {
    const index = '$_appDir/web/index.html';
    _edit(index, (content) {
      final oldName = _html(current.displayName);
      final newName = _html(target.displayName);
      final result = _replaceExact(
        index,
        content,
        '<meta name="apple-mobile-web-app-title" content="$oldName">',
        '<meta name="apple-mobile-web-app-title" content="$newName">',
      );
      return _replaceExact(
        index,
        result,
        '<title>$oldName</title>',
        '<title>$newName</title>',
      );
    });

    const manifest = '$_appDir/web/manifest.json';
    _edit(manifest, (content) {
      final oldName = jsonEncode(current.displayName);
      final newName = jsonEncode(target.displayName);
      final result = _replaceExact(
        manifest,
        content,
        '"name": $oldName,',
        '"name": $newName,',
      );
      return _replaceExact(
        manifest,
        result,
        '"short_name": $oldName,',
        '"short_name": $newName,',
      );
    });
  }

  // --- Localization ----------------------------------------------------------

  /// Updates the `appName` string in the .arb sources and in the generated
  /// intl_utils output, using the same escaping intl_utils produces, so the
  /// generated code stays consistent without running the generator.
  void _localizations() {
    const locale = '$_appDir/lib/presentation/resources/locale';
    for (final arb in _files(
      locale,
      recursive: false,
    ).where((f) => f.endsWith('.arb'))) {
      _edit(
        arb,
        (content) => _replaceExact(
          arb,
          content,
          '"appName": ${jsonEncode(current.displayName)},',
          '"appName": ${jsonEncode(target.displayName)},',
        ),
      );
    }

    for (final messages
        in _files('$locale/generated/intl', recursive: false).where(
          (f) => f.contains('messages_') && !f.endsWith('messages_all.dart'),
        )) {
      _edit(
        messages,
        (content) => _replaceExact(
          messages,
          content,
          '"appName": MessageLookupByLibrary.simpleMessage("${_dartString(current.displayName)}"),',
          '"appName": MessageLookupByLibrary.simpleMessage("${_dartString(target.displayName)}"),',
        ),
      );
    }

    const l10n = '$locale/generated/l10n.dart';
    _edit(l10n, (content) {
      final result = _replaceExact(
        l10n,
        content,
        '/// `${current.displayName}`\n  String get appName',
        '/// `${target.displayName}`\n  String get appName',
      );
      return _replaceExact(
        l10n,
        result,
        "Intl.message('${_dartString(current.displayName)}', name: 'appName'",
        "Intl.message('${_dartString(target.displayName)}', name: 'appName'",
      );
    });
  }

  // --- Project-only automation ---------------------------------------------

  void _sonar() {
    const properties = 'sonar-project.properties';
    _edit(properties, (content) {
      final result = _replacePattern(
        properties,
        content,
        RegExp(r'^sonar\.projectKey=.*$', multiLine: true),
        'sonar.projectKey=${target.packageName}',
        'a sonar.projectKey line',
      );
      return _replacePattern(
        properties,
        result,
        RegExp(r'^sonar\.projectName=.*$', multiLine: true),
        'sonar.projectName=${_propertyValue(target.displayName)}',
        'a sonar.projectName line',
      );
    });
  }

  void _stateFile() {
    _changes[stateFileName] = PlannedFile(
      path: stateFileName,
      content: ProjectState(
        state: RepositoryState.initialized,
        identity: target,
      ).encode(),
    );
  }

  // --- Helpers ---------------------------------------------------------------

  void _edit(String path, String Function(String content) transform) {
    final existing = _changes[path];
    final content = existing?.content ?? _read(path);
    _changes[path] = PlannedFile(
      path: path,
      content: transform(content),
      from: existing?.from,
    );
  }

  String _read(String path) {
    final file = File('${root.path}/$path');
    if (!file.existsSync()) {
      throw TemplateDriftException(path, 'the file itself (it is missing)');
    }
    return file.readAsStringSync();
  }

  Iterable<String> _files(String dir, {required bool recursive}) {
    final directory = Directory('${root.path}/$dir');
    if (!directory.existsSync()) return const [];
    final prefix = directory.absolute.path.length + 1;
    String relative(File file) =>
        file.absolute.path.substring(prefix).replaceAll(r'\', '/');
    return directory
        .listSync(recursive: recursive, followLinks: false)
        .whereType<File>()
        .map((file) => '$dir/${relative(file)}')
        .toList()
      ..sort();
  }

  Iterable<String> _dartFiles(String dir) =>
      _files(dir, recursive: true).where((f) => f.endsWith('.dart'));

  static String _replaceExact(
    String path,
    String content,
    String from,
    String to,
  ) {
    if (!content.contains(from)) {
      throw TemplateDriftException(path, jsonEncode(from));
    }
    return content.replaceAll(from, to);
  }

  static String _replacePattern(
    String path,
    String content,
    RegExp pattern,
    String to,
    String description,
  ) {
    if (!pattern.hasMatch(content)) {
      throw TemplateDriftException(path, description);
    }
    return content.replaceFirst(pattern, to);
  }

  static String _replaceProperty(
    String path,
    String content,
    String key,
    String from,
    String to,
  ) => _replaceExact(path, content, '$key=$from\n', '$key=$to\n');

  /// Escapes a value for a Java .properties file (read as UTF-8 by Gradle).
  static String _propertyValue(String value) =>
      value.startsWith(' ') ? '\\$value' : value;

  static String _html(String value) =>
      const HtmlEscape(HtmlEscapeMode.unknown).convert(value);

  /// Escapes a value the way intl_utils writes it inside a Dart string literal.
  static String _dartString(String value) =>
      value.replaceAll("'", r"\'").replaceAll('"', r'\"');
}
