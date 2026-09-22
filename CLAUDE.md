# CLAUDE.md — Flutter Base (Rootstrap bootstrap template)

## What this repository is

A **reusable company template**, not a product. Teams clone it to start new Flutter apps. Every change
here is inherited by future projects, so optimize for reuse and clear boundaries, and keep
product-specific assumptions out of the base modules.

If you are working in a **project cloned from this template**, the same rules apply, but the example
features (auth, onboarding, home) and the placeholders are yours to replace.
See [docs/development/bootstrap-customization.md](docs/development/bootstrap-customization.md).

## Architecture in one screen

A Dart pub workspace, managed with Melos 7, with one Flutter app and three local path packages, layered like this:

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

- **State management:** `flutter_bloc` Cubits, which live in `domain` (not in `app`). Async screens use
  `BaseCubit<T>`, which emits `Resource<T>` (`RLoading`/`RSuccess`/`RError`).
- **Result flow:** repository returns `Future<ResultType<T>>` (`TSuccess`/`TError`) → service → cubit → `Resource<T>` → widget via `BlocBuilder`.
- **DI:** GetIt. Each package exposes `XInit.initialize(getIt)`. The order in `app/lib/main/init.dart` is Common → Data → Domain.
- **Navigation:** go_router, with the `Routes` enum and `Routers.appRouter` in `app/lib/presentation/navigation/routers.dart`. Auth gating is done with route `redirect` and a root `BlocListener<AuthCubit>`.
- **Networking:** a single Dio instance from `NetworkConfig.provideDio`, with `AuthTokenInterceptor`. The base URL comes from `EnvConfig.apiUrl`.
- **Persistence:** the `Preferences` interface over `SharedPreferences` (in `data`).
- **Errors:** the sealed `Failure` hierarchy plus the `DioException.toFailure()` mapper (in `common`).
- **Flavors:** `dev` / `qa` / `prod` entrypoints + `flutter_dotenv`. Read [docs/architecture/overview.md § Environments](docs/architecture/overview.md#environments-and-flavors) before touching env handling. It has known inconsistencies.

Deeper docs:
- [docs/architecture/overview.md](docs/architecture/overview.md): layers, data flow, DI, navigation, env
- [docs/architecture/modules.md](docs/architecture/modules.md): **module boundaries, dependency rules, creating a module**
- [docs/development/feature-guide.md](docs/development/feature-guide.md): how to add a feature end to end
- [docs/development/testing.md](docs/development/testing.md): testing strategy and commands
- [docs/development/bootstrap-customization.md](docs/development/bootstrap-customization.md): what to change in a new project
- [docs/architecture/known-issues.md](docs/architecture/known-issues.md): verified defects and tech debt. **Read it before "fixing" something that looks wrong.**

## Repository map

```
app/                      Flutter application (package name: app)
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
  android/ ios/ web/ linux/   platform projects
modules/domain/lib/       bloc/, services/, repositories/ (interfaces), models/, env/, init.dart
modules/data/lib/         repositories/ (impls), network/, preferences/, data_sources/ (placeholders), init.dart
modules/common/lib/       core/, devices/, analytics/, ui/, validators/, init.dart
pubspec.yaml (root)       pub workspace root (`workspace:` members) + the `melos:` scripts; one shared pubspec.lock
.fvmrc                    pinned Flutter SDK version (FVM). CI reads it too
.github/workflows/        sonar-qube-scann.yml: analyze + tests + coverage/SonarQube on every PR and push to main
coverage/full_coverage.py multi-package LCOV merge + SonarQube upload
sonar-project.properties  SonarQube config (placeholders)
addModule.py              pulls a module from rootstrap/flutter-modules (see known-issues)
```

## Commands

Prerequisites: FVM (`dart pub global activate fvm`, then `fvm install` installs the Flutter version pinned in
`.fvmrc`, 3.41.3) and Melos 7 (`dart pub global activate melos`). Packages require Dart `>=3.6.0` and Flutter `>=3.41.0`.
Run Flutter through FVM (`fvm flutter …`) so you use the pinned SDK. The commands below say `flutter` for brevity.

| Task | Command (from repo root unless noted) |
|---|---|
| Install deps for the whole workspace | `melos bootstrap` |
| Check toolchain | `melos doctor` |
| Static analysis (CI gate) | `melos run analyze` (runs `dart analyze . --fatal-infos` per package) |
| Format check | `melos run format` (runs `dart format --set-exit-if-changed .` per package, and fails on unformatted code) |
| Analyze + format | `melos run lint:all` |
| Regenerate l10n after editing `.arb` | `cd app && dart run intl_utils:generate` |
| build_runner | `melos run pub:runner`. No generators are configured today (see known-issues #12). |
| Run (dev) | `cd app && flutter run -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev` |
| Run web | `melos run run:web` (uses the **prod** entrypoint `lib/main.dart` with `env/.dev`) |
| Test (CI gate) | `melos exec --dir-exists=test -- flutter test` (runs every package that has a `test/` directory) |
| Coverage + Sonar | `python3 coverage/full_coverage.py --dry-run` (drop `--dry-run` to execute; `--ci` for non-interactive) |
| Build Android | `cd app && flutter build appbundle -t lib/main.dart --dart-define-from-file=<env file>` |
| Build iOS | `cd app && flutter build ipa --release -t lib/main.dart --dart-define-from-file=<env file>` |

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
   `BaseCubit<T>` and use `onResult(...)` or a `switch` on `TSuccess`/`TError`. Do **not** chain
   `mapSuccess`/`mapError` for side effects: `mapError` never calls its callback (known-issues #1).
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
11. **Behavior changes need tests.** See [testing.md](docs/development/testing.md). There are no tests
    yet, so create the package's `test/` directory as the guide describes rather than skipping. CI picks it up automatically.
12. **Report pre-existing problems; don't silently fix them** in unrelated changes. Record them in
    known-issues.md instead.

### Generated / do-not-edit files
- `app/lib/presentation/resources/locale/generated/**`: intl_utils output. Edit the `.arb` files and regenerate.
- `**/generated_plugin_registrant.*`, `app/linux/flutter/generated_*`, `ios/Flutter/Generated.xcconfig`: Flutter tool output.
- `pubspec.lock` (a single workspace lock at the root, git-ignored), `.dart_tool/`, `.fvm/`, `build/`, `coverage/lcov*.info`.
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

- [ ] `melos run format` passes (run `dart format .` in the package to fix)
- [ ] `melos run analyze` passes (it is `--fatal-infos`, so infos fail too)
- [ ] `melos exec --dir-exists=test -- flutter test` passes
- [ ] `.arb` edited in all locales and `dart run intl_utils:generate` output committed
- [ ] New code registered in the right `init.dart`; no forbidden imports (the rules in § Rules and modules.md)
- [ ] App still launches on the dev entrypoint; `flutter build` succeeds for platforms touched
- [ ] Docs updated if you changed a boundary, command, extension point, or env handling
- [ ] PR follows `.github/pull_request_template.md` (description, issue link, preview)

CI (`.github/workflows/sonar-qube-scann.yml`) is meant to run analyze, the tests and coverage/SonarQube on
every PR, but it currently fails before any of them run (missing `SSH_PRIVATE_KEY` secret). It also has no
format or build step. Run the whole checklist locally (known-issues #3).

## Delivery system

This repository can be worked on with Rootshift. None of its files are kept in this repository.

## Other agent instruction files

`.cursor/rules/*.mdc` and `.github/instructions/*.instructions.md` predate this file and partly
contradict the code (naming, global cubits, helpers that don't exist). **Where they conflict, this
file and `docs/` win**, because they describe the code as it is.
