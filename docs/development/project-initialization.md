# Project initialization

The Flutter Base is committed in a **template state**. A team turns a copy of it into a real project with one
command, `melos run init`. This page describes that lifecycle, what the command changes, and what stays manual.

```mermaid
flowchart TD
  A[Clone or "Use this template"] --> B[Template state<br/>flutter_base.json: state = template]
  B --> C[melos run init]
  C --> D[Provide identity<br/>name, package name, bundle ID]
  D --> E[Validate everything, plan every edit]
  E -->|any error| B
  E --> F[Write Dart + Android + iOS + web + l10n + Sonar config<br/>state = initialized]
  F --> G[Project-only automation enabled<br/>SonarQube workflow]
  G --> H[melos bootstrap]
  H --> I[melos run verify + builds]
  I --> J[Ready for development]
```

## Template state vs initialized state

`flutter_base.json` at the repository root is the single source of truth:

```json
{
  "state": "template",
  "identity": {
    "displayName": "RS Base",
    "packageName": "app",
    "androidApplicationId": "com.rs.base",
    "androidNamespace": "com.rootstrap.base.flutter_base_rootstrap",
    "iosBundleId": "com.rs.base"
  }
}
```

- `state` is `template` in the Flutter Base repository and `initialized` in every project created from it.
- `identity` records the values currently written into the repository. The initializer reads it to know what to
  replace, so the template's own identifiers are never hardcoded in the tool.
- The app has no runtime knowledge of the state. It is repository metadata for tooling and CI only.

Scripts and CI read it with `jq -r '.state' flutter_base.json`. The SonarQube workflow does exactly that in its
`gate` job and skips the scan unless the state is `initialized`. Dart tooling can use
`ProjectState.read(root)` from `tool/project_init`.

The template state is a real, buildable app: it analyzes, tests and builds on Android and iOS, and `ci.yml` runs in
both states. Only project-specific automation is off.

## Initialize a project

```bash
git clone <your new repository> && cd <your new repository>
dart pub global activate fvm && fvm install      # Flutter 3.47.5 from .fvmrc
dart pub global activate melos                   # Melos 8.9
melos run init                                   # prompts for the values below
melos bootstrap
melos run verify
```

`melos run init` prompts for each value, suggests a package name derived from the app name, re-asks on invalid
input, shows the full list of changes, and asks for confirmation. To run it non-interactively (scripts, CI, agents),
call the script directly:

```bash
dart tool/project_init/bin/init.dart \
  --name "My App" \
  --package-name my_app \
  --bundle-id com.company.myapp
```

Use the direct `dart` form whenever a value contains spaces: `melos run init -- --name "My App"` does **not** work,
because Melos re-splits forwarded arguments on spaces. The initializer uses only `dart:` libraries, so it runs before
`melos bootstrap`.

### Parameters

| Option | Required | Meaning | Rules |
|---|---|---|---|
| `--name` | yes | Display name: Android launcher label, iOS display name, web title, `appName` string | 1–50 characters, one line, no leading/trailing spaces. Must not contain `$`, `//` or `\`, or start with `@` or `?`, because those break xcconfig, `.properties` or Android resources. |
| `--package-name` | yes | Dart package name of `app/`, and the workspace root name (`<name>_workspace`) | Lowercase letters, digits and `_`, starting with a letter. Not a Dart reserved word, not a workspace package (`common`, `data`, `domain`, `project_init`), and not a dependency name. |
| `--bundle-id` | yes, unless both platform IDs are given | Android `applicationId` + namespace and iOS bundle ID | At least two dot-separated segments. It must also satisfy the Android rules unless `--android-application-id` is given. |
| `--android-application-id` | no | Android ID when it must differ (for example, iOS uses `-`) | Segments start with a letter, contain only letters, digits and `_`, and aren't Java/Kotlin keywords. It is also the namespace and the Kotlin package. |
| `--ios-bundle-id` | no | iOS ID when it must differ | Segments contain only letters, digits and `-`. |
| `--dry-run` | no | Validate and list the changes without writing | |

Exit codes: `0` success, `1` invalid input or error, `2` usage error, `3` already initialized.

### Safety

- Every value is validated before anything is planned, and every edit is computed in memory first. Each one is an
  exact replacement of the value recorded in `flutter_base.json`. If any expected value is missing (the template
  drifted), the run stops and **no file is written**.
- The files are then written together. If a write fails, every file is restored, and moved files are put back.
- **Running it again is refused** (exit code 3) with a message naming the current identity. Nothing is re-applied.
  After initialization, change identifiers by hand, or start again from a fresh copy of the base.

## What `init` changes

| Area | File(s) | Change |
|---|---|---|
| State | `flutter_base.json` | `state` → `initialized`, and `identity` → the new values |
| Workspace | `pubspec.yaml` | `name: <package>_workspace` |
| Dart package | `app/pubspec.yaml`, `app/lib/**`, `app/test/**` | `name: <package>`, and every `package:app/` import |
| Android | `app/android/build.properties` | `flutter.applicationId`, `flutter.namespace`, `flutter.appName` (the launcher label, via a manifest placeholder) |
| Android sources | `app/android/app/src/main/kotlin/<package path>/` | `MainActivity.kt` moves to the new package directory, its `package` line is updated, and empty old directories are removed |
| iOS | `app/ios/Flutter/AppIdentity.xcconfig` | `APP_BUNDLE_ID` and `APP_DISPLAY_NAME`. Every build configuration derives from them (see below) |
| Web | `app/web/index.html`, `app/web/manifest.json` | Title and app names |
| Localization | `intl_*.arb`, `locale/generated/**` | `appName`, written with intl_utils' escaping and then formatted |
| SonarQube | `sonar-project.properties` | `sonar.projectKey=<package>`, `sonar.projectName=<name>` |

iOS configurations derive from `AppIdentity.xcconfig`:

| Configuration | Bundle ID | Display name |
|---|---|---|
| Release / Profile (`Runner` scheme) | `<id>` | `<name>` |
| Debug (`Runner` scheme) | `<id>.debug` | `<name> Debug <version>` |
| Release/Profile dev, Debug dev (`Dev` scheme) | `<id>.dev`, `<id>.debug.dev` | `<name> Dev` |
| Release/Profile qa, Debug qa (`QA` scheme) | `<id>.qa`, `<id>.debug.qa` | `<name> QA`, `<name> QA <version>` |

Android debug builds add `.debug` to the application ID. Android has no product flavors.

What the initializer deliberately does **not** rename: the shared modules (`common`, `data`, `domain`), their
package names and imports, the `Runner` target and schemes, folder names (`app/`, `modules/`), and the
documentation, which describes the template.

## What remains manual

These need values the initializer cannot know, and it never invents them:

- **Environments:** real API URLs and secrets in `app/env/` (one file per flavor; `ENV=<flavor>` selects
  `env/.<flavor>`). Everything in `app/env/` is bundled into the app. See
  [overview.md § Environments](../architecture/overview.md#environments-and-flavors).
- **Android release signing:** `app/android/key.properties` (`storeFile`, `storePassword`, `keyAlias`, `keyPassword`).
  Without it, release builds are signed with the debug key.
- **iOS signing:** the development team and provisioning, in Xcode.
- **Firebase** (optional): uncomment `Firebase.initializeApp` in the entrypoints and add the platform config files.
- **SonarQube:** the repository secrets `SONAR_TOKEN` and `SONAR_URL`. `SSH_PRIVATE_KEY` is only needed for git
  dependencies.
- **Branding:** icons, launch screens, colors and fonts. See [bootstrap-customization.md](bootstrap-customization.md).
- **LICENSE and README** for the new project.

## Verify an initialization

```bash
jq -r .state flutter_base.json                    # initialized
melos bootstrap && melos run verify               # format, analyze, test
cd app
flutter build apk --debug -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev
"$ANDROID_HOME"/build-tools/<version>/aapt2 dump badging build/app/outputs/flutter-apk/app-debug.apk | head -3
flutter build ios --simulator --debug -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev
/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' build/ios/iphonesimulator/Runner.app/Info.plist
```

The APK should report `<android id>.debug` and your app name, and the simulator build `<ios id>.debug`.

## Toolchain requirements

| Tool | Version | Notes |
|---|---|---|
| Flutter / Dart | 3.47.5 / 3.13.4 | Pinned in `.fvmrc`. Packages require `sdk: ^3.13.0`, `flutter: >=3.47.0`. Update with `fvm use <version>` |
| Melos | 8.9 | `dart pub global activate melos`. The workspace pins `melos: ^8.9.0`, and the global CLI delegates to it |
| JDK | 17 | Gradle 9.3.1, Android Gradle Plugin 9.1.0, Kotlin 2.4.0 |
| Android SDK | platform 37 (compileSdk), target 36, min 24 | `sdkmanager "platforms;android-37.0"`. compileSdk 37 is required by `permission_handler` 13. NDK 28.2 is installed by Gradle on first build |
| Xcode | with the iOS 15.0+ SDK (validated with Xcode 27) | Deployment target iOS 15.0 |
| CocoaPods | not needed | iOS uses Swift Package Manager, Flutter's default. If you add a plugin without SPM support, Flutter recreates a Podfile; see the note below |

If a future plugin needs CocoaPods, Flutter adds `#include?` lines for the Pods xcconfigs to `ios/Flutter/Debug.xcconfig`
and `Release.xcconfig`. The flavor files `ios/dev.xcconfig` and `ios/qa.xcconfig` serve three configurations each,
so they would need one xcconfig per configuration to include the matching `Pods-Runner.<config>.xcconfig`.

## Maintaining the initializer

The initializer lives in `tool/project_init/`. It is a pure-Dart workspace member, so `melos run verify` analyzes and
tests it. Its tests copy this repository (the files git tracks) into a temporary directory, initialize it, and check
every location above, including re-runs, invalid input and drift.

When you change a template file the initializer edits (or add a new place that holds project identity), update
`lib/src/plan.dart` and the tests in the same change. If you don't, `melos run test` fails with a
`TemplateDriftException` naming the file.
