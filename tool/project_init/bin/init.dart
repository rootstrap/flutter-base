// Turns a copy of the Flutter Base template into a project.
//
//   melos run init                       # interactive
//   dart tool/project_init/bin/init.dart --name "My App" \
//     --package-name my_app --bundle-id com.company.myapp
//
// Uses only dart: libraries and relative imports so it runs in a fresh clone,
// before `melos bootstrap` has resolved any packages.
import 'dart:io';

// ignore: avoid_relative_lib_imports
import '../lib/project_init.dart';

const _usage = '''
Initialize a project from the Flutter Base template.

Usage:
  melos run init                    Prompts for every value.
  dart tool/project_init/bin/init.dart [options]

Required (prompted when missing and running in a terminal):
  --name                    App display name, e.g. "My App".
  --package-name            Dart package name of the app, e.g. my_app.
  --bundle-id               Android application ID and iOS bundle identifier,
                            e.g. com.company.myapp.

Optional:
  --android-application-id  Android application ID, when it must differ from
                            --bundle-id (Android IDs cannot contain "-").
  --ios-bundle-id           iOS bundle identifier, when it must differ.
  --dry-run                 Validate and list the changes without writing.
  -h, --help                Show this help.

Exit codes: 0 success, 1 invalid input or error, 2 usage error,
3 already initialized.

Values containing spaces cannot be passed through `melos run init --`, because
Melos re-splits arguments; use the prompts or call the script with dart.
''';

const _valueOptions = {
  'name',
  'package-name',
  'bundle-id',
  'android-application-id',
  'ios-bundle-id',
};

Future<void> main(List<String> arguments) async {
  exitCode = await _run(arguments);
}

Future<int> _run(List<String> arguments) async {
  final Map<String, String> options;
  final Set<String> flags;
  try {
    (options, flags) = _parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln('${e.message}\n\n$_usage');
    return 2;
  }
  if (flags.contains('help')) {
    stdout.write(_usage);
    return 0;
  }

  final root = _findRoot();
  if (root == null) {
    stderr.writeln(
      'Could not find $stateFileName. Run this from inside a Flutter Base checkout.',
    );
    return 1;
  }
  final initializer = ProjectInitializer(root);

  try {
    final state = initializer.readState();
    if (state.state == RepositoryState.initialized) {
      // Reuse the initializer's message so the wording lives in one place.
      initializer.run(state.identity, dryRun: true);
    }

    final interactive = stdin.hasTerminal;
    final validator = initializer.validator();
    final prompted = <String>{};

    String value(
      String option,
      String label,
      String? Function(String) validate, {
      String? suggestion,
    }) {
      final given = options[option];
      if (given != null) return given;
      if (!interactive) {
        throw InitException(
          'Missing --$option. Pass every required option, or run '
          'in a terminal to be prompted.\n\n$_usage',
          exitCode: 2,
        );
      }
      prompted.add(option);
      while (true) {
        stdout.write(
          suggestion == null ? '$label: ' : '$label [$suggestion]: ',
        );
        final input = stdin.readLineSync()?.trim() ?? '';
        final answer = input.isEmpty && suggestion != null ? suggestion : input;
        final error = validate(answer);
        if (error == null) return answer;
        stdout.writeln('  $error');
      }
    }

    final name = value('name', 'App name', validator.displayName);
    final packageName = value(
      'package-name',
      'Dart package name',
      validator.packageName,
      suggestion: _suggestPackageName(name),
    );
    final hasAndroidId = options.containsKey('android-application-id');
    final hasIosId = options.containsKey('ios-bundle-id');
    // The shared bundle ID must satisfy the rules of every platform it is
    // used for, so an invalid value is re-asked instead of failing later.
    String? validateBundleId(String id) =>
        (hasAndroidId ? null : validator.androidApplicationId(id)) ??
        (hasIosId ? null : validator.iosBundleId(id));
    final bundleId = hasAndroidId && hasIosId
        ? options['ios-bundle-id']!
        : value('bundle-id', 'Bundle ID (Android + iOS)', validateBundleId);
    final androidId = options['android-application-id'] ?? bundleId;
    final iosId = options['ios-bundle-id'] ?? bundleId;

    final target = ProjectIdentity(
      displayName: name,
      packageName: packageName,
      androidApplicationId: androidId,
      androidNamespace: androidId,
      iosBundleId: iosId,
    );

    final dryRun = flags.contains('dry-run');
    final preview = initializer.run(target, dryRun: true);
    _printPlan(preview, root);
    if (dryRun) {
      stdout.writeln('\nDry run: nothing was written.');
      return 0;
    }
    if (prompted.isNotEmpty && !_confirm('\nApply these changes?')) {
      stdout.writeln('Cancelled. Nothing was written.');
      return 1;
    }

    initializer.run(target);
    _printNextSteps(target);
    return 0;
  } on InitException catch (e) {
    stderr.writeln(e.message);
    return e.exitCode;
  } on TemplateDriftException catch (e) {
    stderr.writeln(e);
    return 1;
  } on FormatException catch (e) {
    stderr.writeln('Could not read $stateFileName: ${e.message}');
    return 1;
  }
}

(Map<String, String>, Set<String>) _parse(List<String> arguments) {
  final options = <String, String>{};
  final flags = <String>{};
  for (var i = 0; i < arguments.length; i++) {
    final argument = arguments[i];
    if (argument == '-h' || argument == '--help') {
      flags.add('help');
      continue;
    }
    if (argument == '--dry-run') {
      flags.add('dry-run');
      continue;
    }
    if (!argument.startsWith('--')) {
      throw FormatException('Unexpected argument "$argument".');
    }
    final separator = argument.indexOf('=');
    final key = argument.substring(2, separator == -1 ? null : separator);
    if (!_valueOptions.contains(key)) {
      throw FormatException('Unknown option "--$key".');
    }
    if (separator != -1) {
      options[key] = argument.substring(separator + 1);
    } else if (i + 1 < arguments.length && !arguments[i + 1].startsWith('--')) {
      options[key] = arguments[++i];
    } else {
      throw FormatException('Option "--$key" needs a value.');
    }
  }
  return (options, flags);
}

/// Walks up from the current directory to the checkout that holds the state
/// file, so the script works from the root and from `tool/project_init`.
Directory? _findRoot() {
  var dir = Directory.current.absolute;
  while (true) {
    if (File('${dir.path}/$stateFileName').existsSync()) return dir;
    final parent = dir.parent;
    if (parent.path == dir.path) return null;
    dir = parent;
  }
}

String? _suggestPackageName(String name) {
  final suggestion = name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return RegExp(r'^[a-z]').hasMatch(suggestion) ? suggestion : null;
}

bool _confirm(String question) {
  stdout.write('$question [y/N]: ');
  final answer = stdin.readLineSync()?.trim().toLowerCase();
  return answer == 'y' || answer == 'yes';
}

void _printPlan(InitResult result, Directory root) {
  final from = result.previous;
  final to = result.identity;
  stdout
    ..writeln('Project identity')
    ..writeln(
      '  App name              ${from.displayName}  ->  ${to.displayName}',
    )
    ..writeln(
      '  Dart package          ${from.packageName}  ->  ${to.packageName}',
    )
    ..writeln(
      '  Android applicationId ${from.androidApplicationId}  ->  ${to.androidApplicationId}',
    )
    ..writeln(
      '  Android namespace     ${from.androidNamespace}  ->  ${to.androidNamespace}',
    )
    ..writeln(
      '  iOS bundle identifier ${from.iosBundleId}  ->  ${to.iosBundleId}',
    )
    ..writeln('\nFiles (${result.files.length}):');
  for (final file in result.files) {
    stdout.writeln(
      file.isMove
          ? '  move  ${file.from}\n     -> ${file.path}'
          : '  edit  ${file.path}',
    );
  }
}

void _printNextSteps(ProjectIdentity identity) {
  stdout.writeln('''

Initialized "${identity.displayName}". $stateFileName now reports "initialized",
so the project-only CI workflow (SonarQube) is enabled.

Next steps:
  melos bootstrap
  melos run verify          # format, analyze, test
  cd app && flutter run -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev

Still manual (the initializer never invents these values):
  - API URLs and secrets in app/env/ (one file per flavor)
  - Android release signing: app/android/key.properties
  - iOS signing team and provisioning in Xcode
  - Firebase configuration, if you use Firebase
  - SonarQube: the SONAR_TOKEN and SONAR_URL repository secrets
  - LICENSE and README for the new project
See docs/development/project-initialization.md.''');
}
