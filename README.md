[![License](https://img.shields.io/github/license/rootstrap/ios-base.svg)](https://github.com/rootstrap/flutter-base/blob/master/LICENSE.md)

# Flutter Base Template

Flutter base is a boilerplate project created by Rootstrap for new projects using Flutter. The main
objective is helping any new projects jump start into feature development by providing a handful of
functionalities.

## Documentation

- [CLAUDE.md](CLAUDE.md): the entry point for AI agents and a quick reference for developers (architecture, commands, rules, definition of done)
- [Architecture overview](docs/architecture/overview.md) · [Module guide](docs/architecture/modules.md) · [Known issues](docs/architecture/known-issues.md)
- [Feature development](docs/development/feature-guide.md) · [Testing](docs/development/testing.md) · [Bootstrap customization](docs/development/bootstrap-customization.md)

Where this README and `docs/` disagree, `docs/` reflects the current code (see known-issues #15).

# Features

This template comes with:

- Melos 8 workspace scripts, and a one-command project initializer (`melos run init`).
- Dependency injection (GetIt).
- HttpClient already configured for Rootstrap BE Projects(Dio).
- Theming setup.
- Navigation Router and DeepLinks config with go_router
- Intl.
- State Management (Blocs/Cubit).
- Env config and flavors.
- Chat with Gemini and Vertex AI (Documentation and setup WIP)
- GitWorkflow config: RS-GPT-Review
- GitWorkflow config: Sonarqube

## Initial Setup

This repository is a **template**: `flutter_base.json` says `"state": "template"`, and project-only automation
(SonarQube) is off. One command turns a copy of it into your project.
See [docs/development/project-initialization.md](docs/development/project-initialization.md) for everything it does.

1. Create a new repo using this template, and clone it.

   ![template](app/template.png)
2. Install [FVM](https://fvm.app) and the Flutter version pinned in `.fvmrc` (3.47.5):
```text
    dart pub global activate fvm
    fvm install
```
   Run Flutter through FVM (`fvm flutter <command>`), or add `alias flutter='fvm flutter'`.
3. Install [Melos](https://melos.invertase.dev/getting-started) 8 globally. If your shell can't find `melos`,
   add `export PATH="$PATH":"$HOME/.pub-cache/bin"` to `~/.zshrc` or `~/.bashrc`:
```text
    dart pub global activate melos
```
4. Initialize the project. It prompts for the app name, Dart package name and bundle ID, and shows every change
   before applying it:
```text
    melos run init
```
   Non-interactive form (use it when the name contains spaces):
```text
    dart tool/project_init/bin/init.dart --name "My App" --package-name my_app --bundle-id com.company.myapp
```
5. Bootstrap the workspace and check everything:
```text
    melos bootstrap
    melos run verify
```
6. Add your environment values. Each flavor reads `app/env/.<flavor>` (see `app/env/.dev`):
```text
    API_URL=https://your-api.example.com
    ENV=dev
```
   ![me](env_config_files.png)
7. Android release signing: create a keystore and `app/android/key.properties`. Without it, release builds use the
   debug key.
```text
   keytool -genkey -v -keystore ~/keystore_name.jks -keyalg RSA -keysize 2048 -validity 10000 -alias your_alias
```
```text
    storePassword=<YourStorePassword>
    keyPassword=<YourKeyPassword>
    keyAlias=<YourStoreAlias>
    storeFile=<FilePath>
```
8. iOS signing: set your team in Xcode (`app/ios/Runner.xcworkspace`).

Toolchain: JDK 17, Android SDK platform 37 (`sdkmanager "platforms;android-37.0"`), Xcode with the iOS 15+ SDK.
CocoaPods is not needed; iOS plugins use Swift Package Manager.

> Melos 8 uses [Dart pub workspaces](https://dart.dev/tools/pub/workspaces). The workspace is declared in the root `pubspec.yaml`, each package sets `resolution: workspace`, and there is a single shared `pubspec.lock` at the repo root.

### Upgrading the pinned Flutter version

When the team agrees to move to a new Flutter version, run `fvm use <version>` at the repo root and commit the updated `.fvmrc`. CI reads the pinned version from `.fvmrc`, so the change propagates automatically.

### IDE setup

- **VS Code**: settings are already wired in `.vscode/settings.json` — the Dart extension picks up `.fvm/flutter_sdk` automatically.
- **Android Studio / IntelliJ**: open `Preferences → Languages & Frameworks → Flutter` and set the SDK path to `<repo>/.fvm/flutter_sdk`.

## Set up an editor

- Follow the [Android Studio](https://docs.flutter.dev/get-started/editor?tab=androidstudio)
  instructions to setup the editor

- Follow the [VS Code](https://docs.flutter.dev/get-started/editor?tab=vscode) instructions to setup
  the editor

## Running the App

1. Open a Simulator or Emulator
2. Open your project in your editor of preference

**Note:** Starting with **Flutter 2.8** in order for you to launch the app in **Android** you must
define the `flutter.compileSdkVersion` inside the `local.properties` file.

You can read more about
this [here](https://docs.page/bizz84/complete-flutter-course/faq/android-build-gradle-issues).

### Android Studio

1. Add a **Run Configuration**
    1. Add new **Flutter** configuration
    2. Give it a meaningful name **IE:** Dev, QA, Staging, Prod
    3. Pick the entry point, main.dart file location **IE:** ``.../lib/main/env/main_dev.dart``
2. Include any additional run arguments to launch the app.
    1. Create each env files config files in your root **app/**
       ![me](env_config_files.png)
    2. Setup your build, add the env file to the build command in AE:
       ![me](env_config.png)
3. Setup your env vars, i.e the api_url for each env:
    ```text
        {
            "API_URL": "https://dummyjson.com"
        }
    ```
4. Select the device to launch the App
5. Run the App

### VS Code

1. Go to **Run and Debug** section at the **Activity Bar**
2. At the top of the section expand the list and **Add Configuration**
3. Insert **Flutter Launch** configuration
    1. Update the environment name **(dev)**
    2. Update the launch program path **``/lib/main/env/main_dev.dart``**
    3. Update the **Flutter Mode** (debug, profile, release)
    4. Include any additional run argments to launch the app.
        1. Environment variables

           Add the env vars for each flavor with the property ``toolArgs``
           ![launch configuration example](app/vs-code-launch-configuration.png)

4. Inside the **Run and Debug** section select the environment you want to excute
5. Make sure you have the device you want to use already open
6. Run the App

**Note 1:** Create as much **Launch Configurations** as you need for any specific environment.

**Note 2:** You shouldn't commit the **``.vscode/launch.json``** file.

## Build Production App:

The production entry point is `lib/main.dart`. Run the commands from `app/`. The env file passed to
`--dart-define-from-file` must define `ENV=prod`, because `init.dart` then loads `env/.prod` as the dotenv file.
Create `app/env/.prod` first (following `app/env/.dev`) and don't commit real secrets.

1. Build your android appBundle or apk:
    - run the following command to build your appBundle

    ```text
        flutter build appbundle -t lib/main.dart --dart-define-from-file=env/.prod
    ```

   [TODO: add how to setup Xcode for apple signIn]
2. Configure your iOs app sigIn.
    - run the following command to build your ipa

    ```text
        flutter build ipa --release -t lib/main.dart --dart-define-from-file=env/.prod
    ```

For more information you can check the [docs](https://dartcode.org/docs/launch-configuration/)

## Packages

- [GetIt](https://pub.dev/packages/get_it) For dependency injection.
- [Dio](https://pub.dev/packages/dio) A http client.
- [Blocs](https://pub.dev/packages/bloc) and [Cubit](https://pub.dev/packages/flutter_bloc) as State
  management library.

## Utilities

- [intl](https://pub.dev/packages/intl) and [intl_utils](https://pub.dev/packages/intl_utils) for
  localization.
- [flutter_svg](https://pub.dev/packages/flutter_svg) Svg Image loader.
- Auto generate translations files with [intl_utils](https://pub.dev/packages/intl_utils).
 
-  ```text
         dart run intl_utils:generate
    ```
## Code Quality Standards

In order to meet the required code quality standards, this project is following
this [tech guides considerations](https://github.com/rootstrap/tech-guides/blob/master/flutter/README.md)
.
It also runs [flutter analyze](https://dart.dev/tools/dart-analyze) for each build on your CI/CD
tool.

## Security recommendations

### Obfuscation

TBD

## CI/CD configuration with Bitrise (updated on Dec 12th 2021)

We are using Bitrise to configure and run
the [CI/CD pipelines](https://www.notion.so/rootstrap/Flutter-CI-CD-9a0a5957ee8442908fc00c3ea8f49bf1)

### Github Actions: RS-GPT-Review
- Configure GPT secrets vars on your repo settings:
    - OPENAI_KEY
#### Note: The action will only run if the description or comments mentions @rs-gpt-review

### Github Actions: Sonarqube
- Go to you sonarqube server and configure a new project.
- Configure the sonar-project.properties:
    example:
    '''
        sonar.projectKey=your-app-key
        sonar.projectName=your-project-name
        sonar.host.url=https://your-sonarqube-server.net
        sonar.projectVersion=1.0
        sonar.sourceEncoding=UTF-8
    '''
# Main source directories
sonar.sources=app/lib,modules/domain,modules/data,modules/common
sonar.dart.exclusions=pubspec.yaml
sonar.dart.analyzer.report.mode=LEGACY
- Configure Sonarqube secrets vars on your repo settings:
  - SONAR_TOKEN (your sonarqube project token)
  - SONAR_URL (your sonarqube server url)

## License

Flutter-Base is available under the MIT license. See the LICENSE file for more info.

**NOTE:** Remove the free LICENSE file for private projects or replace it with the corresponding
license.

## Credits

**Flutter Base** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of
our [contributors](https://github.com/rootstrap/flutter-base/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
