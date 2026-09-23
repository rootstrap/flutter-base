# Flutter Base Template

Flutter Base is Rootstrap's starting point for new Flutter apps. It gives a new project a working architecture,
tooling and CI from day one, so the team can start on features right away.

This repository is a **template**, not a product. You don't develop in it directly: you create a repository from it
and run one command (`melos run init`) that turns the copy into your project. The example features (auth,
onboarding, home, splash) are there to show the patterns. Replace them with your own.

## What's included

- **Architecture:** a Dart pub workspace with one app and three packages (`domain`, `data`, `common`) and enforced
  dependency direction. See [modules.md](docs/architecture/modules.md).
- **State management:** `flutter_bloc` Cubits, with `BaseCubit<T>` and a `Resource<T>` loading/success/error state.
- **Dependency injection:** GetIt, registered per package.
- **Networking:** a Dio client with an auth-token interceptor and failure mapping.
- **Navigation:** go_router, with auth redirects and deep links (app_links).
- **Environments:** `dev` / `qa` / `prod` entrypoints and flutter_dotenv files.
- **Localization:** intl + intl_utils (English and Spanish).
- **Theming:** Material 3 light and dark themes.
- **Tooling:** Melos 8 scripts, the project initializer, FVM-pinned Flutter, and GitHub Actions CI with an optional
  SonarQube scan.

## Requirements

| Tool | Version | Install |
|---|---|---|
| Flutter / Dart | 3.47.5 / 3.13.4, pinned in `.fvmrc` | `dart pub global activate fvm`, then `fvm install` in the repo |
| Melos | 8.9+ | `dart pub global activate melos` |
| JDK | 17 | For Android builds |
| Android SDK | platform 37 | `sdkmanager "platforms;android-37.0"` |
| Xcode | with the iOS 15.0+ SDK | For iOS builds. CocoaPods is **not** needed: iOS plugins use Swift Package Manager |

If your shell can't find `fvm` or `melos`, add `export PATH="$PATH":"$HOME/.pub-cache/bin"` to `~/.zshrc` or
`~/.bashrc`.

Always run Flutter through FVM (`fvm flutter <command>`), or add `alias flutter='fvm flutter'`, so everyone uses
the pinned SDK. Melos scripts already use it.

## Start a new project

1. **Create your repository** from this template on GitHub ("Use this template"), and clone it.

   ![template](app/template.png)

2. **Install the pinned Flutter version** from the repository root:

   ```bash
   fvm install
   ```

3. **Initialize the project.** The command prompts for the app name, the Dart package name and the bundle ID, shows
   every change, and asks for confirmation:

   ```bash
   melos run init
   ```

   To run it without prompts (scripts, CI, agents), call the script directly. Use this form whenever a value
   contains spaces:

   ```bash
   dart tool/project_init/bin/init.dart --name "My App" --package-name my_app --bundle-id com.company.myapp
   ```

   Add `--dry-run` to preview the changes. Init validates everything before writing, and it runs **only once**; after
   that, change identifiers by hand. The parameters, rules and every file it edits are in
   [project-initialization.md](docs/development/project-initialization.md).

4. **Install dependencies and check everything:**

   ```bash
   melos bootstrap
   melos run verify     # format, analyze and test, as CI does
   ```

5. **Set up the environments** (see [Environments](#environments)).

6. **Run the app** (see [Run the app](#run-the-app)).

7. **Finish the manual steps.** Init can't know these values:
   - **Android release signing:** create a keystore and `app/android/key.properties`:

     ```bash
     keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
     ```

     ```properties
     storePassword=<store password>
     keyPassword=<key password>
     keyAlias=upload
     storeFile=<absolute path to the .jks file>
     ```

     Don't commit this file or the keystore. Without `key.properties`, release builds are signed with the **debug
     key**, which the Play Store rejects.
   - **iOS signing:** open `app/ios/Runner.xcworkspace` in Xcode and set your team and provisioning for the
     `Runner` target.
   - **Firebase** (optional): add the platform config files and uncomment `Firebase.initializeApp` in the
     entrypoints.
   - **SonarQube** (optional): add the `SONAR_TOKEN` and `SONAR_URL` repository secrets (see [CI](#ci)).
   - **Branding:** app icons, launch screens, colors and fonts. See
     [bootstrap-customization.md](docs/development/bootstrap-customization.md).
   - **This README and a LICENSE** that fit your project.

## Environments

Each environment has an entrypoint and an env file in `app/env/`:

| Environment | Entrypoint (`-t`) | Env file |
|---|---|---|
| dev | `lib/main/env/main_dev.dart` | `env/.dev` (committed, as an example) |
| qa | `lib/main/env/main_qa.dart` | `env/.qa` (create it) |
| prod | `lib/main.dart` | `env/.prod` (create it) |

An env file looks like this:

```properties
API_URL=https://your-api.example.com
ENV=dev
```

Pass it with `--dart-define-from-file=env/.<env>`. Its `ENV` value also selects which file flutter_dotenv loads, so
`ENV` must match the file name (`ENV=prod` in `env/.prod`).

> **Everything in `app/env/` is bundled into the app** and can be read by anyone who has the binary. Never put real
> secrets there. Details and known inconsistencies:
> [overview.md § Environments](docs/architecture/overview.md#environments-and-flavors).

## Run the app

From `app/`:

```bash
# dev
fvm flutter run -t lib/main/env/main_dev.dart --dart-define-from-file=env/.dev

# qa
fvm flutter run -t lib/main/env/main_qa.dart --dart-define-from-file=env/.qa
```

- **iOS:** add `--flavor dev` or `--flavor qa` to use the `Dev`/`QA` schemes. Each installs with its own bundle ID
  (`<id>.debug.dev`, `<id>.debug.qa`), so the environments can sit side by side on one device.
- **Android:** don't pass `--flavor`. Android has no product flavors, so the entrypoint alone selects the
  environment, and every environment installs as `<id>.debug`.
- **Web:** `melos run run:web` runs the dev environment in Chrome.

**VS Code:** create a `.vscode/launch.json` (it is git-ignored) with one configuration per environment:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "dev",
      "request": "launch",
      "type": "dart",
      "cwd": "app",
      "program": "lib/main/env/main_dev.dart",
      "toolArgs": ["--dart-define-from-file=env/.dev"]
    }
  ]
}
```

`.vscode/settings.json` already points the Dart extension at the FVM SDK.

**Android Studio:** set the Flutter SDK path to `<repo>/.fvm/flutter_sdk` (Settings → Languages & Frameworks →
Flutter). Then add a Flutter run configuration per environment, with the entrypoint as "Dart entrypoint" and
`--dart-define-from-file=env/.dev` as "Additional run args".

## Everyday commands

Run these from the repository root:

| Task | Command |
|---|---|
| Install dependencies (whole workspace) | `melos bootstrap` |
| Everything CI checks: format, analyze, test | `melos run verify` |
| Static analysis (infos are fatal) | `melos run analyze` |
| Format check | `melos run format` (fix with `dart format .` in the package) |
| Tests | `melos run test` |
| Regenerate localization after editing `.arb` files | `melos run gen:l10n` |
| Check the toolchain | `melos run doctor` |

A change is done when `melos run verify` passes and the app launches. The full checklist is in
[CLAUDE.md § Definition of done](CLAUDE.md#definition-of-done).

**Before you add code**, read these:
- [Feature guide](docs/development/feature-guide.md): add a feature end to end (repository → service → cubit → page).
- [Module guide](docs/architecture/modules.md): what goes in which package, and which imports are allowed.
- [Testing](docs/development/testing.md): what to test and how.
- [Known issues](docs/architecture/known-issues.md): verified defects. Read it before "fixing" something that looks
  wrong.

Key conventions:
- Put user-facing strings in `app/lib/presentation/resources/locale/intl_*.arb` (all locales), then regenerate.
  Never edit `locale/generated/`.
- Take spacing from `Dimen` and colors from the theme; don't hardcode them.
- Keep repository interfaces in `domain` and their implementations in `data`. Pages talk to cubits, not to
  repositories.

## Build for release

Run these from `app/`, after creating `env/.prod` (with `ENV=prod`) and setting up signing:

```bash
fvm flutter build appbundle -t lib/main.dart --dart-define-from-file=env/.prod
fvm flutter build ipa --release -t lib/main.dart --dart-define-from-file=env/.prod
```

The version comes from `version:` in `app/pubspec.yaml`, for both platforms.

## CI

GitHub Actions runs on every pull request and every push to `main`:

- **`ci.yml`:** format, analyze and tests, plus an Android debug build. It runs in the template and in every project.
- **`sonar-qube-scann.yml`:** coverage and a SonarQube scan. It runs **only in initialized projects**: its `gate` job
  reads `flutter_base.json` and skips the scan in the template. To enable it, add the repository secrets `SONAR_TOKEN`
  and `SONAR_URL`, and review `sonar-project.properties`. `SSH_PRIVATE_KEY` is only needed if you add private git
  dependencies.

CI reads the Flutter version from `.fvmrc`.

## Upgrading Flutter

When the team agrees on a new version, run `fvm use <version>` at the repository root, update the `sdk`/`flutter`
constraints in the pubspecs if needed, check `melos run verify` and the platform builds, and commit the updated
`.fvmrc`.

## Contributing to the template

These apply only when you change **this** repository, not a project created from it:

- Keep it committed in the template state. `flutter_base.json` must say `"state": "template"`. Never commit the
  result of running `melos run init`.
- Every change is inherited by future projects. Keep the base modules generic and free of product-specific names,
  endpoints or rules.
- If you change a file the initializer edits, update `tool/project_init/lib/src/plan.dart` in the same change. If you
  add or upgrade a dependency, the initializer tests may ask you to add package names to
  `tool/project_init/lib/src/resolved_packages.dart`. See
  [project-initialization.md § Maintaining the initializer](docs/development/project-initialization.md#maintaining-the-initializer).
- Follow the pull request template in `.github/pull_request_template.md`.

## Documentation

- [CLAUDE.md](CLAUDE.md): quick reference for developers and AI agents (architecture, commands, rules, definition of
  done).
- Architecture: [overview](docs/architecture/overview.md) · [modules](docs/architecture/modules.md) ·
  [known issues](docs/architecture/known-issues.md)
- Development: [project initialization](docs/development/project-initialization.md) ·
  [feature guide](docs/development/feature-guide.md) · [testing](docs/development/testing.md) ·
  [bootstrap customization](docs/development/bootstrap-customization.md)

## Credits

**Flutter Base** is maintained by [Rootstrap](https://www.rootstrap.com) with the help of
our [contributors](https://github.com/rootstrap/flutter-base/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](https://www.rootstrap.com)
