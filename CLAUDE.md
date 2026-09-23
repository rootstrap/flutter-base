# CLAUDE.md — Flutter Base (Rootstrap bootstrap template)

## What this repository is

A **reusable company template**, not a product. Teams clone it to start new Flutter apps. Every change
here is inherited by future projects, so optimize for reuse and clear boundaries, and keep
product-specific assumptions out of the base modules.

### Template or project? Check `flutter_base.json`

`flutter_base.json` → `"state"` says which one you are in:

- **`"template"`**: this is the Flutter Base itself. Keep project-specific values (real app names, bundle IDs,
  endpoints, secrets) out of it. Project-only automation (the SonarQube workflow) is switched off.
- **`"initialized"`**: a project created from the base with `melos run init`. The example features (auth,
  onboarding, home) and the remaining manual placeholders are yours to replace.

Never edit `flutter_base.json` or the identity values by hand to switch state. The lifecycle, parameters and
manual steps are in [docs/development/project-initialization.md](docs/development/project-initialization.md).

## Architecture in one screen

A Dart pub workspace, managed with Melos 8, with one Flutter app and three local path packages, layered like this:

```
app  ──►  domain  ──►  common
 │  ╲                   ▲
 │   ╲──►  data  ───────┘      data ──► domain (implements its interfaces)
 └──────────────────────► common
```

| Package | Role | Holds |
|---|---|---|
| `app/` | Presentation + composition root | Pages, widgets, go_router routes, theme, l10n, flavor entrypoints, DI bootstrap |
| `modules/domain/` | Business logic | Cubits and states, services, repository **interfaces**, models, `EnvConfig` |
| `modules/data/` | Data access | Repository **implementations**, Dio `NetworkConfig`, interceptors, `Preferences` (shared_preferences) |
| `modules/common/` | Shared utilities with no feature knowledge | `ResultType`, `Resource`, `Failure`, platform/permission abstractions, analytics interface, validators |

`tool/project_init/` is a fifth workspace member: the pure-Dart project initializer (tooling, not an app layer).

- **State management:** `flutter_bloc` Cubits, which live in `domain` (not in `app`). Async screens use
  `BaseCubit<T>`, which emits `Resource<T>` (`RLoading`/`RSuccess`/`RError`).
- **Result flow:** repository returns `Future<ResultType<T>>` (`TSuccess`/`TError`) → service → cubit → `Resource<T>` → widget via `BlocBuilder`.
- **DI:** GetIt. Each package exposes `XInit.initialize(getIt)`. The order in `app/lib/main/init.dart` is Common → Data → Domain.
- **Navigation:** go_router, with the `Routes` enum and `Routers.appRouter` in `app/lib/presentation/navigation/routers.dart`. Auth gating is done with route `redirect` and a root `BlocListener<AuthCubit>`.
- **Networking:** a single Dio instance from `NetworkConfig.provideDio`, with `AuthTokenInterceptor`. The base URL comes from `EnvConfig.apiUrl`.
- **Persistence:** the `Preferences` interface over `SharedPreferences` (in `data`).
- **Errors:** the sealed `Failure` hierarchy plus the `DioException.toFailure()` mapper (in `common`).
- **Flavors:** `dev` / `qa` / `prod` entrypoints + `flutter_dotenv`. Read [docs/architecture/overview.md § Environments](docs/architecture/overview.md#environments-and-flavors) before touching env handling. It has known inconsistencies.
- **Project identity** (name, package, bundle IDs) is kept in a few files the initializer owns: `flutter_base.json`,
  `app/android/build.properties`, `app/ios/Flutter/AppIdentity.xcconfig` (see the repository map).

Deeper docs:
- [docs/architecture/overview.md](docs/architecture/overview.md): layers, data flow, DI, navigation, env
- [docs/architecture/modules.md](docs/architecture/modules.md): **module boundaries, dependency rules, creating a module**
- [docs/development/feature-guide.md](docs/development/feature-guide.md): how to add a feature end to end
- [docs/development/testing.md](docs/development/testing.md): testing strategy and commands
- [docs/development/project-initialization.md](docs/development/project-initialization.md): **template vs project, `melos run init`, toolchain requirements**
- [docs/development/bootstrap-customization.md](docs/development/bootstrap-customization.md): what to keep, customize or replace in a new project
- [docs/architecture/known-issues.md](docs/architecture/known-issues.md): verified defects and tech debt. **Read it before "fixing" something that looks wrong.**

## Repository map

```
flutter_base.json         repository state (template | initialized) + current identity. Written only by the initializer
app/                      Flutter application (Dart package `app` in the template; init renames it)
  lib/main.dart           prod entrypoint
  lib/main/env/           main_dev.dart, main_qa.dart, env_config.dart (Flavor, FlavorConfig, Environment)
  lib/main/init.dart      composition root: dotenv load, GetIt registration, runApp
  lib/main/app.dart       MaterialApp.router, global BlocProviders, deep-link initial location
  lib/presentation/
    navigation/           Routes enum + GoRouter tree
    ui/pages/<area>/<feature>/   screens (auth/login, auth/sign_up, onboarding, main/home, splash)
    ui/components/        reusable design-system widgets (PrimaryButton)
    ui/custom/            app-wide custom widgets (DebugBanner, Cookies, FailureWidget, ...)
    ui/base/              TrackedPage + RouteObserver (analytics scaffolding)
    themes/               LocalTheme, AppThemes, light/dark palettes (Material 3 tonal)
    resources/            Dimen, Images (part files of resources.dart), locale/*.arb + generated/
  env/                    dotenv files bundled as assets (.dev, .env.example)
  test/                   app tests
  android/build.properties   Android identity (applicationId, namespace, label) + SDK levels
  ios/Flutter/AppIdentity.xcconfig  iOS identity (APP_BUNDLE_ID, APP_DISPLAY_NAME). Flavor xcconfigs: ios/dev.xcconfig, ios/qa.xcconfig
  android/ ios/ web/ linux/   platform projects (iOS uses Swift Package Manager, no CocoaPods)
modules/domain/lib/       bloc/, services/, repositories/ (interfaces), models/, env/, init.dart
modules/data/lib/         repositories/ (impls), network/, preferences/, data_sources/ (placeholders), init.dart
modules/common/lib/       core/, devices/, analytics/, ui/, validators/, init.dart
tool/project_init/        the initializer (bin/init.dart, lib/src/, tests that initialize a copy of this repo)
pubspec.yaml (root)       pub workspace root (`workspace:` members) + the `melos:` scripts; one shared pubspec.lock
.fvmrc                    pinned Flutter SDK version (FVM). CI reads it too
.github/workflows/        ci.yml: format + analyze + test + Android build (template and project)
                          sonar-qube-scann.yml: coverage + SonarQube, project-only (skipped in the template)
coverage/full_coverage.py multi-package LCOV merge + SonarQube upload
sonar-project.properties  SonarQube config (placeholders)
addModule.py              pulls a module from rootstrap/flutter-modules (see known-issues)
```

## Commands

Toolchain: Flutter **3.47.5** (Dart **3.13.4**) pinned in `.fvmrc` (`dart pub global activate fvm`, then `fvm install`),
Melos **8.9** (`dart pub global activate melos`), JDK **17**, Android SDK platform **37** (compileSdk; install it with
`sdkmanager "platforms;android-37.0"`), and Xcode with the iOS 15+ SDK. CocoaPods is not needed. Run Flutter through
FVM (`fvm flutter …`) so you use the pinned SDK; the commands below say `flutter` for brevity.

| Task | Command (from repo root unless noted) |
|---|---|
| Initialize a project (template only) | `melos run init` (prompts), or `dart tool/project_init/bin/init.dart --name "My App" --package-name my_app --bundle-id com.company.myapp`. Add `--dry-run` to preview. |
| Install deps for the whole workspace | `melos bootstrap` |
| Everything CI checks | `melos run verify` (format, analyze, test) |
| Static analysis | `melos analyze` (same as `melos run analyze`: `dart analyze . --fatal-infos` per package) |
| Format (fails if a file changed) | `melos format` (same as `melos run format`) |
| Test | `melos run test` (`flutter test` in Flutter packages, `dart test` in pure-Dart ones) |
| Regenerate l10n after editing `.arb` | `melos run gen:l10n` |
| build_runner | `melos run pub:runner` (only packages that depend on build_runner; none use generators today) |
| Run (dev) | `cd app && flutter run -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev` |
| Run web (dev) | `melos run run:web` |
| Check toolchain | `melos doctor` |
| Coverage + Sonar | `python3 coverage/full_coverage.py --dry-run` (drop `--dry-run` to execute; `--ci` for non-interactive) |
| Build Android | `cd app && flutter build apk --debug -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev` (release: `flutter build appbundle -t lib/main.dart --dart-define-from-file=<env file>`) |
| Build iOS | `cd app && flutter build ios --simulator --debug -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev` (release: `flutter build ipa --release -t lib/main.dart --dart-define-from-file=<env file>`) |

`analyze`, `format` and `test` are root scripts that shadow Melos's built-in commands of the same name, so
`melos analyze` and `melos run analyze` run the same thing. Don't make such a script call the built-in: it recurses.

Flavors: iOS has `Dev`/`QA`/`Runner` schemes (`--flavor dev|qa` works on iOS). Android has **no**
`productFlavors`, so select the environment with `-t <entrypoint>` only. Details are in overview.md.

## Rules for changing this repository

1. **Respect dependency direction.** `common` depends on no workspace package. `domain` depends only on
   `common`. `data` depends on `domain` + `common`. `app` depends on all three. Never import `app` from a
   module, never import `data` from `domain`, and in `app` import `package:data/...` **only** from
   `lib/main/init.dart` (DI). Full rules are in [modules.md](docs/architecture/modules.md).
2. **Interfaces in `domain`, implementations in `data`.** Presentation talks to cubits and services, not to
   repositories or Dio. (`ui/custom/cookies.dart` violates this. It is a known exception, don't copy it.)
3. **Follow the established result pipeline.** Repositories return `ResultType<T>`. Cubits extend
   `BaseCubit<T>` and use `onResult(...)` or a `switch` on `TSuccess`/`TError`.
4. **Register everything in the owning package's `init.dart`.** Global cubits are singletons in
   `DomainInit`. Screen-scoped cubits should be created with `BlocProvider(create: ...)` at the page.
5. **Reuse before adding.** Check `common/core`, `BaseCubit`, `ListBlocState`, `PrimaryButton`,
   `FailureWidget`, `Dimen`, `context.colors`/`context.theme`, and `FormValidator` first.
6. **User-facing strings go in `app/lib/presentation/resources/locale/intl_*.arb`** (both `en` and `es`),
   then regenerate. Never hand-edit `locale/generated/`.
7. **Spacing and sizes come from `Dimen`**, and colors come from the theme (`Theme.of(context).colorScheme`
   or `context.colors`). Don't hardcode them in new code.
8. **Keep the base generic.** No product names, endpoints, or business rules in `common`, `domain/bloc/base_cubit.dart`,
   `data/network/`, or the theme scaffolding. Example features stay clearly examples.
9. **Don't introduce a second pattern** (Riverpod, Provider-only state, another HTTP client, another DI
   container, freezed/json_serializable) without an explicit architecture decision.
10. **Don't edit generated or platform-generated files** (see below).
    Identity files (`flutter_base.json`, `android/build.properties` identity keys, `ios/Flutter/AppIdentity.xcconfig`)
    are changed by the initializer. If you change a template file the initializer edits, update
    `tool/project_init/lib/src/plan.dart` too; its tests fail if the two drift apart.
11. **Behavior changes need tests.** See [testing.md](docs/development/testing.md). Only `common` and `domain`
    have a few, so create the package's `test/` directory as the guide describes rather than skipping. CI picks it up automatically.
12. **Report pre-existing problems; don't silently fix them** in unrelated changes. Record them in
    known-issues.md instead.

### Generated / do-not-edit files
- `app/lib/presentation/resources/locale/generated/**`: intl_utils output. Edit the `.arb` files and regenerate.
- `**/generated_plugin_registrant.*`, `app/linux/flutter/generated_*`, `ios/Flutter/Generated.xcconfig`: Flutter tool output.
- `pubspec.lock` (a single workspace lock at the root, git-ignored), `.dart_tool/`, `.fvm/`, `build/`, `coverage/lcov*.info`.
- `flutter_base.json`: written by the initializer only.
- If you add build_runner generators: `*.g.dart`, `*.freezed.dart`, `*.mocks.dart` (already excluded in Sonar and coverage).

## Before implementing

1. Identify the affected package(s) and layer(s), using the table above.
2. Read the matching section in `docs/`, and the package's `lib/**/README.md` if present.
3. Find the closest existing example. **Canonical references:** auth
   (`AuthRepository` → `AuthRepositoryImpl` → `AuthService` → `AuthCubit` → `login_form.dart`) for a
   request/response flow, and `AppCubit` + `CommonRepository` for persisted settings.
4. Check dependency direction for every new import.
5. List the existing abstractions you will reuse.
6. Decide the tests you'll add (cubit, repository, widget).

## Definition of done

- [ ] `melos run verify` passes (format, analyze with fatal infos, test). `format` rewrites files, so commit the result
- [ ] In the template, `flutter_base.json` still says `"template"` and no project-specific values were added
- [ ] `.arb` edited in all locales and `melos run gen:l10n` output committed
- [ ] New code registered in the right `init.dart`; no forbidden imports (the rules in § Rules and modules.md)
- [ ] App still launches on the dev entrypoint; `flutter build` succeeds for platforms touched
- [ ] Docs updated if you changed a boundary, command, extension point, or env handling
- [ ] PR follows `.github/pull_request_template.md` (description, issue link, preview)

CI (`.github/workflows/ci.yml`) runs `melos run verify` and an Android debug build on every PR, in the template and
in projects. iOS is not built in CI, so build it locally when you touch iOS or shared native configuration.

## Delivery system

This repository can be worked on with Rootshift. None of its files are kept in this repository.

## Other agent instruction files

`.cursor/rules/*.mdc` and `.github/instructions/*.instructions.md` predate this file and partly
contradict the code (naming, global cubits, helpers that don't exist). **Where they conflict, this
file and `docs/` win**, because they describe the code as it is.
