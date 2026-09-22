@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:project_init/project_init.dart';
import 'package:test/test.dart';

/// These tests initialize a copy of the real repository, so they fail as soon
/// as the template changes in a way the initializer does not handle.
void main() {
  final repositoryRoot = Directory.current.parent.parent;
  final repositoryState = ProjectState.read(repositoryRoot).state;
  late Directory copy;

  test('flutter_base.json is readable', () {
    expect(repositoryState, isA<RepositoryState>());
  });

  // The initializer only runs on the template. In a project created from it,
  // these tests would (correctly) be refused, so they are skipped.
  group(
    'on the template',
    skip: repositoryState == RepositoryState.initialized
        ? 'the repository is initialized; the initializer only runs on the template'
        : false,
    () {
      const target = ProjectIdentity(
        displayName: "Joe's Café",
        packageName: 'joes_cafe',
        androidApplicationId: 'com.example.joescafe',
        androidNamespace: 'com.example.joescafe',
        iosBundleId: 'com.example.joes-cafe',
      );

      setUp(() => copy = _copyRepository(repositoryRoot));
      tearDown(() => copy.deleteSync(recursive: true));

      String read(String path) => File('${copy.path}/$path').readAsStringSync();

      test('initializes every project-specific location', () {
        final template = ProjectState.read(copy).identity;
        ProjectInitializer(copy, formatGeneratedCode: false).run(target);

        final state = ProjectState.read(copy);
        expect(state.state, RepositoryState.initialized);
        expect(state.identity.toJson(), target.toJson());

        expect(read('pubspec.yaml'), startsWith('name: joes_cafe_workspace\n'));
        expect(read('app/pubspec.yaml'), startsWith('name: joes_cafe\n'));

        final dartFiles = Directory('${copy.path}/app/lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .map((f) => f.readAsStringSync());
        expect(dartFiles.any((c) => c.contains('package:joes_cafe/')), isTrue);
        expect(
          dartFiles.any((c) => c.contains('package:${template.packageName}/')),
          isFalse,
        );

        final properties = read('app/android/build.properties');
        expect(
          properties,
          contains('flutter.applicationId=com.example.joescafe\n'),
        );
        expect(
          properties,
          contains('flutter.namespace=com.example.joescafe\n'),
        );
        expect(properties, contains("flutter.appName=Joe's Café\n"));

        const kotlin = 'app/android/app/src/main/kotlin';
        expect(
          read('$kotlin/com/example/joescafe/MainActivity.kt'),
          startsWith('package com.example.joescafe\n'),
        );
        // com/rootstrap/... is removed; com/ stays because the new package uses it.
        final oldSegments = template.androidNamespace.split('.');
        for (final dir in [
          oldSegments.join('/'),
          oldSegments.take(2).join('/'),
        ]) {
          expect(
            Directory('${copy.path}/$kotlin/$dir').existsSync(),
            isFalse,
            reason: 'empty package directory $dir is removed',
          );
        }

        final xcconfig = read('app/ios/Flutter/AppIdentity.xcconfig');
        expect(xcconfig, contains('APP_BUNDLE_ID=com.example.joes-cafe\n'));
        expect(xcconfig, contains("APP_DISPLAY_NAME=Joe's Café\n"));

        expect(
          read('app/web/index.html'),
          contains('<title>Joe&#39;s Café</title>'),
        );
        expect(
          jsonDecode(read('app/web/manifest.json'))['short_name'],
          "Joe's Café",
        );

        const locale = 'app/lib/presentation/resources/locale';
        expect(
          jsonDecode(read('$locale/intl_en.arb'))['appName'],
          "Joe's Café",
        );
        expect(
          read('$locale/generated/intl/messages_en.dart'),
          contains(r'''simpleMessage("Joe\'s Café")'''),
        );
        expect(
          read('$locale/generated/l10n.dart'),
          contains(r"""Intl.message('Joe\'s Café', name: 'appName'"""),
        );

        final sonar = read('sonar-project.properties');
        expect(sonar, contains('sonar.projectKey=joes_cafe\n'));
        expect(sonar, contains("sonar.projectName=Joe's Café\n"));

        // Documentation describes the template, so only project files are checked.
        for (final file in _repositoryFiles(Directory('${copy.path}/app'))) {
          if (!_isText(file)) continue;
          final content = file.readAsStringSync();
          expect(
            content.contains(template.androidNamespace),
            isFalse,
            reason: file.path,
          );
          expect(
            content.contains('APP_BUNDLE_ID=${template.iosBundleId}'),
            isFalse,
            reason: file.path,
          );
        }
      });

      test('refuses to run twice and leaves the project untouched', () {
        final initializer = ProjectInitializer(copy, formatGeneratedCode: false)
          ..run(target);
        final before = _snapshot(copy);

        expect(
          () => initializer.run(target),
          throwsA(
            isA<InitException>().having(
              (e) => e.exitCode,
              'exitCode',
              alreadyInitializedExitCode,
            ),
          ),
        );
        expect(_snapshot(copy), before);
      });

      test('writes nothing when the input is invalid', () {
        final before = _snapshot(copy);
        const invalid = ProjectIdentity(
          displayName: 'Ok',
          packageName: 'common',
          androidApplicationId: 'com.example.my-app',
          androidNamespace: 'com.example.my-app',
          iosBundleId: 'app',
        );

        expect(
          () =>
              ProjectInitializer(copy, formatGeneratedCode: false).run(invalid),
          throwsA(
            isA<InitException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('already used'),
                contains('application ID'),
                contains('bundle identifier'),
              ),
            ),
          ),
        );
        expect(_snapshot(copy), before);
      });

      test('writes nothing when the template has drifted', () {
        final xcconfig = File(
          '${copy.path}/app/ios/Flutter/AppIdentity.xcconfig',
        );
        xcconfig.writeAsStringSync(
          xcconfig.readAsStringSync().replaceAll('APP_BUNDLE_ID', 'BUNDLE'),
        );
        final before = _snapshot(copy);

        expect(
          () =>
              ProjectInitializer(copy, formatGeneratedCode: false).run(target),
          throwsA(isA<TemplateDriftException>()),
        );
        expect(_snapshot(copy), before);
      });

      test('dry run validates and plans without writing', () {
        final before = _snapshot(copy);
        final result = ProjectInitializer(copy).run(target, dryRun: true);

        expect(result.files.map((f) => f.path), contains(stateFileName));
        expect(result.files.where((f) => f.isMove), hasLength(1));
        expect(_snapshot(copy), before);
      });

      test(
        'the CLI initializes non-interactively and reports a re-run',
        () async {
          final script = '${copy.path}/tool/project_init/bin/init.dart';
          final arguments = [
            script,
            '--name',
            "Joe's Café",
            '--package-name',
            'joes_cafe',
            '--bundle-id',
            'com.example.joescafe',
          ];

          final first = await Process.run(
            Platform.resolvedExecutable,
            arguments,
            workingDirectory: copy.path,
          );
          expect(first.exitCode, 0, reason: '${first.stdout}\n${first.stderr}');
          expect(first.stdout, contains('melos bootstrap'));
          expect(read(generatedMessages), contains('Joe'));

          final second = await Process.run(
            Platform.resolvedExecutable,
            arguments,
            workingDirectory: copy.path,
          );
          expect(second.exitCode, alreadyInitializedExitCode);
          expect(second.stderr, contains('already initialized'));
        },
      );

      test(
        'the CLI requires an Android-safe bundle ID unless one is given',
        () async {
          final script = '${copy.path}/tool/project_init/bin/init.dart';
          final shared = ['--name', 'App', '--package-name', 'my_app'];

          final rejected = await Process.run(Platform.resolvedExecutable, [
            script,
            ...shared,
            '--bundle-id',
            'com.example.my-app',
          ], workingDirectory: copy.path);
          expect(rejected.exitCode, 1);
          expect(rejected.stderr, contains('--android-application-id'));
          expect(ProjectState.read(copy).state, RepositoryState.template);

          final accepted = await Process.run(Platform.resolvedExecutable, [
            script,
            ...shared,
            '--bundle-id',
            'com.example.my-app',
            '--android-application-id',
            'com.example.my_app',
          ], workingDirectory: copy.path);
          expect(accepted.exitCode, 0, reason: '${accepted.stderr}');
          final identity = ProjectState.read(copy).identity;
          expect(identity.iosBundleId, 'com.example.my-app');
          expect(identity.androidApplicationId, 'com.example.my_app');
        },
      );

      test(
        'the CLI rejects missing options when not running in a terminal',
        () async {
          final result = await Process.run(Platform.resolvedExecutable, [
            '${copy.path}/tool/project_init/bin/init.dart',
            '--name',
            'App',
          ], workingDirectory: copy.path);
          expect(result.exitCode, 2);
          expect(result.stderr, contains('Missing --package-name'));
        },
      );
    },
  );
}

const generatedMessages =
    'app/lib/presentation/resources/locale/generated/intl/messages_en.dart';

/// Copies the files git tracks (plus new, unignored ones) into a temp dir.
Directory _copyRepository(Directory root) {
  final copy = Directory.systemTemp.createTempSync('project_init_test_');
  final listed = Process.runSync('git', [
    'ls-files',
    '--cached',
    '--others',
    '--exclude-standard',
    '-z',
  ], workingDirectory: root.path);
  if (listed.exitCode != 0) {
    throw StateError('git ls-files failed: ${listed.stderr}');
  }
  for (final path
      in (listed.stdout as String).split('\x00').where((p) => p.isNotEmpty)) {
    final source = File('${root.path}/$path');
    if (!source.existsSync()) continue;
    final destination = File('${copy.path}/$path')
      ..parent.createSync(recursive: true);
    source.copySync(destination.path);
  }
  return copy;
}

bool _isText(File file) =>
    !const ['.png', '.jpg', '.ttf', '.jar', '.ico'].any(file.path.endsWith);

Iterable<File> _repositoryFiles(Directory root) =>
    root.listSync(recursive: true).whereType<File>();

Map<String, String> _snapshot(Directory root) => {
  for (final file in _repositoryFiles(root))
    file.path.substring(root.path.length): base64Encode(file.readAsBytesSync()),
};
