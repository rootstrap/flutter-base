# Testing guide

## Current state (verified)

- **Very few tests:** `modules/common/test/core/result_type_test.dart` and `modules/domain/test/env/env_config_test.dart`.
  `app` and `data` have no `test/` directory.
- There are no integration tests (`integration_test/`), no golden tests, and no mocks or fakes checked in.
- The test dependencies are declared but unused:
  - `app`: `flutter_test`, `bloc_test`, `mocktail`, `build_runner`
  - `domain`, `data`: `flutter_test`, `mocktail`
  - `tool/project_init` (pure Dart): `test`. Its suite initializes a temporary copy of the repository
  - `common`: `flutter_test` only
- There's no coverage threshold. Coverage is collected and uploaded to SonarQube by `coverage/full_coverage.py`.
- CI (`.github/workflows/ci.yml`) runs `melos run verify` (format, analyze, test) on every PR.

## Commands

| What | Command |
|---|---|
| All packages (what CI runs) | `melos run test` (from the repo root; `flutter test` in Flutter packages, `dart test` in pure-Dart ones) |
| One package | `cd <pkg> && flutter test` (`dart test` in `tool/project_init`) |
| One file | `flutter test test/path/to/file_test.dart` (from the package dir) |
| Coverage for one package | `flutter test --coverage` → `<pkg>/coverage/lcov.info` |
| Merged coverage + Sonar | `python3 coverage/full_coverage.py` (interactive), `--ci`, or `--dry-run` |

Use `fvm flutter` if `flutter` isn't aliased to the pinned SDK. A package's tests only run once it has a `test/`
directory: `melos run test` and `full_coverage.py` (which iterates the packages listed in
`sonar.sources`) both skip packages without one.

## Expected conventions for new tests

These follow from the declared dev dependencies and the architecture. Keep new suites consistent with them.

- **Location**: mirror `lib/` under the owning package's `test/`, for example
  `modules/domain/test/bloc/auth/auth_cubit_test.dart` for `modules/domain/lib/bloc/auth/auth_cubit.dart`. File suffix `_test.dart`.
- **Cubits (domain)**: use `bloc_test`'s `blocTest` with a `mocktail` mock of the service. Assert the `Resource` sequence
  (`RLoading` → `RSuccess`/`RError`). `bloc_test` is currently only an `app` dev dependency, so add it to
  `modules/domain/pubspec.yaml` `dev_dependencies` (then `melos bootstrap`) when you write the first domain cubit test.
- **Services**: plain `test` with a mocked repository interface.
- **Repositories (data)**: mock `Dio` / `Preferences` with `mocktail`. Cover DTO → model
  mapping and `DioException` → `Failure` for each error type you handle.
- **Common utilities**: pure unit tests (`FormValidator`, `ResultType`, `FailureMapper`, `Resource`). These are the cheapest
  high-value tests in the repo.
- **Widgets (app)**: `testWidgets`, providing cubits with `BlocProvider.value` over a `MockCubit` (from `bloc_test`).
  Localized widgets need `localizationsDelegates: LangExtensions.appLocalizationDelegates` on the test `MaterialApp`.
  Anything that reads `getIt` needs registrations in `setUp`. Call `GetIt.instance.reset()` in `tearDown`.
- **Mocks**: use `mocktail` (no codegen). It's the only mocking library declared. Don't add `mockito`, which needs
  build_runner and produces generated `*.mocks.dart` files.
- When you add a package's first tests, add `<pkg>/test` to `sonar.tests` in `sonar-project.properties`. It
  currently lists `modules/common/test` and `modules/domain/test`, which are the directories that exist.
- Changing a template file the initializer edits? Run `cd tool/project_init && dart test`; it fails on drift.

## What a change must test

| Change | Minimum tests |
|---|---|
| New/changed cubit | `blocTest` for each public method: success and error paths |
| New/changed repository impl | mapping + each failure path |
| New/changed common utility | unit tests covering its branches |
| New page / significant widget | widget test for the loading, error, and success renderings |
| Bug fix | a regression test that fails without the fix |
