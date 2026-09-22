# Bootstrap customization guide

What to keep, what to change, and what to delete when starting a new project from this template.
Start with `melos run init` ([project-initialization.md](project-initialization.md)): it applies the project identity
everywhere. This page covers what comes after.

## What each part of the template is

| Category | What | Guidance |
|---|---|---|
| **Base infrastructure** (keep) | Package layout and dependency direction; `XInit` DI pattern; `ResultType`/`Resource`/`Failure`; `BaseCubit`, `ListBlocState`, `CancelableCubitMixin`; `NetworkConfig` + `AuthTokenInterceptor`; `Preferences`; `AppCubit` (theme/lang); `Routes` enum + go_router shells; `LocalTheme`/`ThemeColors` scaffolding; intl setup; platform/permission abstractions; the pub workspace + Melos scripts (root `pubspec.yaml`); `.fvmrc`; `coverage/full_coverage.py` | Preserve these. Change them only through an architecture decision, and upstream improvements to the template. |
| **Extension points** (customize) | `ThemeColors` palettes (`light_theme_colors.dart`, `dark_theme_colors.dart`); `LocalTheme` text styles + fonts; `Dimen`; `Images` enum; `.arb` files; `AnalyticsClient` implementation; `PermissionManager` methods; `Preferences` keys; `NetworkConstants`; `AuthTokenInterceptor` header/clear policy; `FlavorValues` (empty, for per-flavor values); `TrackedPage` | Designed to be filled in per project. |
| **Example / reference** (replace) | Auth flow (`AuthRepositoryImpl` is a fake that sleeps and stores `'new-token'`), login/sign-up pages, onboarding (4 placeholder pages), home, splash, `/app/placeholder` route, `User` model, cookies banner, `EnvironmentSelector`, `DebugBanner` | They show the patterns. Rewrite them against your real backend and design, keeping the same shape. |
| **Placeholders** (must replace) | See the checklist below | Leaving any of these in production is a defect. |
| **Generated** (never hand-edit) | `app/lib/presentation/resources/locale/generated/**`; Flutter plugin registrants; `ios/Flutter/Generated.xcconfig`; `flutter_base.json` (the initializer's) | Regenerate them instead. |
| **Protected boundaries** | Dependency rules in [modules.md](../architecture/modules.md#dependency-rules); interfaces in domain / impls in data; Common → Data → Domain init order | Changing these needs an explicit decision. |

## New-project checklist

### Identity
- [ ] Run `melos run init`. It sets the app name, Dart package name, Android application ID and namespace (and moves
  `MainActivity.kt`), the iOS bundle ID and display names, web titles, `appName`, and the Sonar project key and name.
  Don't edit those by hand. The full list is in [project-initialization.md](project-initialization.md#what-init-changes).
- [ ] Package descriptions ("A new Flutter project." / "A new Flutter package project.") and the template `README.md` /
  `CHANGELOG.md` in each `modules/*`.
- [ ] License: `app/LICENSE.md`, `modules/*/LICENSE` (MIT). Replace or remove them for private projects (the README says so).

### Environments
- [ ] Decide on one env scheme and fix the drift described in [overview.md § Environments](../architecture/overview.md#environments-and-flavors)
  and known-issues #2. `EnvConfig.apiUrl` accepts either `API_URL_<FLAVOR>` or `API_URL`. Pick one layout and document it.
- [ ] Create env files per flavor, and don't commit real secrets. Everything in `app/env/` is bundled into the app as an asset.
  `SECRET_KEY` in `env/.dev` is a placeholder.
- [ ] Check the iOS flavor targets (`FLUTTER_TARGET` in `ios/Flutter/*.xcconfig`, `ios/dev.xcconfig`, `ios/qa.xcconfig`) if you
  add or rename entrypoints.
- [ ] Android product flavors (if you need them). None exist today.
- [ ] `NetworkConstants`: timeouts (2 s is aggressive), `tokenHeader` (`"token"`), and the example `productsPath` / `baseUrl`.

### Branding and design
- [ ] Palettes in `themes/resources/*_theme_colors.dart` (currently the Material 3 baseline purple), and `borderRadius` in `app_themes.dart`.
- [ ] Fonts (`app/fonts/`, `pubspec.yaml` `fonts:`, and the family names in `LocalTheme`).
- [ ] App icons (`android/app/src/main/res/mipmap-*`, `ios/Runner/Assets.xcassets/AppIcon.appiconset`), launch screens, and `web/icons`.
- [ ] `Images.appLogo` points to `assets/icons/logo.png`, which doesn't exist. Add the asset and a `pubspec.yaml` entry.

### Integrations
- [ ] Firebase: uncomment and fill in `Firebase.initializeApp` in `main.dart`, `main_dev.dart`, and `main_qa.dart`, and add the platform config files
  (`google-services.json` / `GoogleService-Info.plist`, which are git-ignored in `app/.gitignore`).
- [ ] Analytics: implement `AnalyticsClient` (for example, finish `FirebaseAnalytics`), register it in GetIt, call
  `SetupAnalytics.initialize()`, and add `routeObserver` to `GoRouter(observers: [...])`.
- [ ] Auth: replace `AuthRepositoryImpl` with real API calls, and check `AuthTokenInterceptor`'s "clear everything on
  401/403/422" policy.
- [ ] Deep links: `app_links` is wired for the initial link, but there's no Android intent filter or iOS associated
  domains config. Add them per platform.

### Signing and release
- [ ] Android: create a keystore and `android/key.properties` (git-ignored). `build.gradle` reads `storeFile`, `storePassword`,
  `keyAlias`, and `keyPassword`.
- [ ] iOS: signing team and provisioning profiles in Xcode. None are committed, and the README marks this as TODO.
- [ ] Versioning: `version:` in `app/pubspec.yaml` is the single source for Android and iOS. Bump it there, or pass
  `--build-name` / `--build-number` to `flutter build`.

### CI/CD and quality
- [ ] `ci.yml` (format, analyze, test, Android build) needs no setup.
- [ ] SonarQube starts running once the project is initialized. Add the repository secrets `SONAR_TOKEN` and `SONAR_URL`
  (and `SSH_PRIVATE_KEY` only if you add git-based pub dependencies). `sonar-project.properties` gets its key and name
  from `init`.
- [ ] Bump the Flutter version with `fvm use <version>` and commit `.fvmrc`. CI follows it.
- [ ] iOS isn't built in CI. Add a macOS job if the project needs it.
- [ ] `.github/pull_request_template.md`: adjust the issue-tracker link.

### Clean-up of examples
- [ ] Remove or replace the example pages and strings you don't need (onboarding copy, "Sorry we didn't find any product", terms hint).
- [ ] Remove the `/app/placeholder` route.
- [ ] Remove the unused dependencies you don't adopt (see known-issues #13).
