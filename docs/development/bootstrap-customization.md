# Bootstrap customization guide

What to keep, what to change, and what to delete when starting a new project from this template.
This complements the step-by-step setup in the root `README.md`.

## What each part of the template is

| Category | What | Guidance |
|---|---|---|
| **Base infrastructure** (keep) | Package layout and dependency direction; `XInit` DI pattern; `ResultType`/`Resource`/`Failure`; `BaseCubit`, `ListBlocState`, `CancelableCubitMixin`; `NetworkConfig` + `AuthTokenInterceptor`; `Preferences`; `AppCubit` (theme/lang); `Routes` enum + go_router shells; `LocalTheme`/`ThemeColors` scaffolding; intl setup; platform/permission abstractions; the pub workspace + Melos scripts (root `pubspec.yaml`); `.fvmrc`; `coverage/full_coverage.py` | Preserve these. Change them only through an architecture decision, and upstream improvements to the template. |
| **Extension points** (customize) | `ThemeColors` palettes (`light_theme_colors.dart`, `dark_theme_colors.dart`); `LocalTheme` text styles + fonts; `Dimen`; `Images` enum; `.arb` files; `AnalyticsClient` implementation; `PermissionManager` methods; `Preferences` keys; `NetworkConstants`; `AuthTokenInterceptor` header/clear policy; `FlavorValues` (empty, for per-flavor values); `TrackedPage` | Designed to be filled in per project. |
| **Example / reference** (replace) | Auth flow (`AuthRepositoryImpl` is a fake that sleeps and stores `'new-token'`), login/sign-up pages, onboarding (4 placeholder pages), home, splash, `/app/placeholder` route, `User` model, cookies banner, `EnvironmentSelector`, `DebugBanner` | They show the patterns. Rewrite them against your real backend and design, keeping the same shape. |
| **Placeholders** (must replace) | See the checklist below | Leaving any of these in production is a defect. |
| **Generated** (never hand-edit) | `app/lib/presentation/resources/locale/generated/**`; Flutter plugin registrants; `ios/Flutter/Generated.xcconfig` | Regenerate them instead. |
| **Protected boundaries** | Dependency rules in [modules.md](../architecture/modules.md#dependency-rules); interfaces in domain / impls in data; Common → Data → Domain init order | Changing these needs an explicit decision. |

## New-project checklist

### Identity
- [ ] `android/build.properties`: `flutter.appId`, versions, SDK levels. The applicationId becomes `com.rs.<appId>`.
  Change the `"com.rs."` prefix in `android/app/build.gradle` if you aren't using Rootstrap's namespace.
- [ ] Android `namespace` and Kotlin package `com.rootstrap.base.flutter_base_rootstrap` (`android/app/build.gradle`,
  `AndroidManifest.xml` `package`, `src/main/kotlin/.../MainActivity.kt`).
- [ ] `android:label="flutter_base_rootstrap"` in `AndroidManifest.xml`.
- [ ] iOS `FLUTTER_APP_ID` / `FLUTTER_APP_NAME` in `ios/Flutter/Debug.xcconfig`, `ios/Flutter/Release.xcconfig`,
  `ios/dev.xcconfig`, and `ios/qa.xcconfig` ("RS Base …"). The bundle ID becomes `com.rs.$(FLUTTER_APP_ID)`, and the `com.rs.` prefix is
  in `project.pbxproj` `PRODUCT_BUNDLE_IDENTIFIER`.
- [ ] `CFBundleName` `flutter_base_rootstrap` in `ios/Runner/Info.plist`.
- [ ] Web: `<title>` / `apple-mobile-web-app-title` in `web/index.html`, and `web/manifest.json` name, description, and colors.
- [ ] `appName` ("Flutter Target") in the `.arb` files.
- [ ] Package descriptions ("A new Flutter project." / "A new Flutter package project.") and the template `README.md` /
  `CHANGELOG.md` in each `modules/*`.
- [ ] Root `pubspec.yaml` `name: flutter_base_workspace` / `description`, if you want the workspace named after the project.
- [ ] License: `app/LICENSE.md`, `modules/*/LICENSE` (MIT). Replace or remove them for private projects (the README says so).

### Environments
- [ ] Decide on one env scheme and fix the drift described in [overview.md § Environments](../architecture/overview.md#environments-and-flavors)
  and known-issues #2. Today the committed `env/.dev` doesn't provide the `API_URL_DEV` key that `EnvConfig.apiUrl` reads.
- [ ] Create env files per flavor, and don't commit real secrets. Everything in `app/env/` is bundled into the app as an asset.
  `SECRET_KEY` in `env/.dev` is a placeholder.
- [ ] Fix the flavor targets: `ios/qa.xcconfig` points `FLUTTER_TARGET` at `main_dev.dart` (with `PREFIX=dev`), and
  `ios/Flutter/Release.xcconfig` points at the non-existent `lib/main/env/main.dart`.
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
- [ ] Versioning: `version:` in `app/pubspec.yaml` (1.0.0+1), which Flutter writes into `android/local.properties`, and that's what
  `build.gradle` reads. The `flutter.versionName/Code` in `build.properties` are **not** read by Gradle. The iOS xcconfigs
  also set `FLUTTER_BUILD_NAME/NUMBER` (2.0.0). These disagree today. Pick one source.

### CI/CD and quality
- [ ] `.github/workflows/sonar-qube-scann.yml` runs on every PR and push to `main` (analyze, tests, coverage + SonarQube),
  using the Flutter version from `.fvmrc`. Set the secrets `SONAR_TOKEN` and `SONAR_URL`. It also requires
  `SSH_PRIVATE_KEY`, which is only needed for git-based pub dependencies (there are none), so either set it or drop the
  `ssh-agent` step. Without it, the job fails at that step (known-issues #3).
- [ ] Bump the Flutter version with `fvm use <version>` and commit `.fvmrc`. CI follows it.
- [ ] `sonar-project.properties`: `projectKey`, `projectName`, `host.url`. `sonar.tests` lists `modules/domain/test`,
  which doesn't exist yet.
- [ ] Add `melos run format` and a `flutter build` to CI. The current workflow runs neither (the README also mentions Bitrise
  and an RS-GPT-Review action, but neither is configured in this repo).
- [ ] `.github/pull_request_template.md`: adjust the issue-tracker link.

### Clean-up of examples
- [ ] Remove or replace the example pages and strings you don't need (onboarding copy, "Sorry we didn't find any product", terms hint).
- [ ] Remove the `/app/placeholder` route.
- [ ] Remove the unused dependencies you don't adopt (see known-issues #13).
