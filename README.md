[![License](https://img.shields.io/github/license/rootstrap/ios-base.svg)](https://github.com/rootstrap/flutter-base/blob/master/LICENSE.md)

# Flutter Base Template

Flutter base is a boilerplate project created by Rootstrap for new projects using Flutter. The main
objective is helping any new projects jump start into feature development by providing a handful of
functionalities.

# Features

This template comes with:

- Dependency injection (GetIt).
- HttpClient already configured for Rootstrap BE Projects(Dio).
- Theming setup.
- Intl.
- State Management (Blocs/Cubit).
- Env config and flavors.

## Initial Setup

1. Create a new repo using this template.
   ![template](template.png)
2. Clone your new repo.
3. Run `flutter doctor`.
4. Run `flutter pub get`.

## Set up an editor

- Follow the [Android Studio](https://docs.flutter.dev/get-started/editor?tab=androidstudio) instructions to setup the editor

- Follow the [VS Code](https://docs.flutter.dev/get-started/editor?tab=vscode) instructions to setup the editor

## Running the App

1. Open a Simulator or Emulator
2. Open your project in your editor of preference

### Android Studio

1. Add a **Run Configuration**
    1. Add new **Flutter** configuration
    2. Give it a meaningful name **IE:** Dev, QA, Staging, Prod
    3. Pick the entry point, main.dart file location **IE:** ``.../lib/main/env/main_dev.dart``
    4. Include any additional run arguments to launch the app, **IE:** Environment Variables.
2. Select the device to launch the App
3. Run the App

### VS Code

1. Go to **Run and Debug** section at the **Activity Bar**
2. At the top of the section expand the list and **Add Configuration**
3. Insert **Flutter Launch** configuration
    1. Update the environment name **(dev)**
    2. Update the launch program path **``/lib/main/env/main_dev.dart``**
    3. Update the **Flutter Mode** (debug, profile, release)

![launch configuration example](vs-code-launch-configuration.png)

**Note 1:** Create as much **Launch Configurations** as you need for any specific environment.

**Note 2:** You shouldn't commit the **``.vscode/launch.json``** file.

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
- [dart_code_metrics] (<https://dartcodemetrics.dev/docs/rules>) Dart code static analysis code.

## Code Quality Standards

In order to meet the required code quality standards, this project is following
this [tech guides considerations](https://github.com/rootstrap/tech-guides/blob/master/flutter/README.md).
It also runs [flutter analyze](https://dart.dev/tools/dart-analyze) for each build on your CI/CD tool.

## Security recommendations

### Third Party Keys

We strongly recommend that all private keys should be saved as ENV Vars on each platform. Our
Flavors config already manages this. In Android Studio, add the env var for each flavor:
![me](env_var_config.png)

Android: Go to `android -> app -> build.gradle` and add your env var name like this:

```
    def dartEnvironmentVariables = [
        YOUR_DEV_API_KEY: null
    ]
```

iOS: No extra configuration needed.

## CI/CD configuration with Bitrise (updated on Dec 12th 2021)

We are using Bitrise to configure and run
the [CI/CD pipelines](https://www.notion.so/rootstrap/Flutter-CI-CD-9a0a5957ee8442908fc00c3ea8f49bf1).

## License

Flutter-Base is available under the MIT license. See the LICENSE file for more info.

**NOTE:** Remove the free LICENSE file for private projects or replace it with the corresponding
license.

## Credits

**Flutter Base** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of
our [contributors](https://github.com/rootstrap/flutter-base/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
