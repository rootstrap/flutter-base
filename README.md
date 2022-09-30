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

## How to use

1. Clone repo.
2. Run `flutter doctor`.
3. Run `flutter pub get`.
4. Initialize a new git repo and add your remote url.
5. Run your project
6. Done!

## Packages

- [GetIt](https://pub.dev/packages/get_it) For dependency injection.
- [Dio](https://pub.dev/packages/dio) A http client.
- [Blocs](https://pub.dev/packages/bloc) and [Cubit](https://pub.dev/packages/flutter_bloc) as State
  management library.

## Utilities

- [intl](https://pub.dev/packages/intl) and [intl_utils](https://pub.dev/packages/intl_utils) for
  localization.
- [flutter_svg](https://pub.dev/packages/flutter_svg) Svg Image loader.

## Code Quality Standards

In order to meet the required code quality standards, this project si following
this [tech guides considerations](https://github.com/rootstrap/tech-guides/blob/master/flutter/README.md)
Also runs [flutter analyze](https://dart.dev/tools/dart-analyze) for each build on your CI/CD tool.

## Security recommendations

### Third Party Keys

We strongly recommend that all private keys should be saved as ENV Vars on each platform, our Flavors config. already manage it.
In your Android Studio add the env var for each flavor:
![me](env_var_config.png)

Android: go to `android -> app -> build.gradle` and add your env var name like this:
```
    def dartEnvironmentVariables = [
        YOUR_DEV_API_KEY: null
    ]
```

iOs: Not extra configuration needed.

## CI/CD configuration with Bitrise (updated on Dec 12th 2021)

We are going to use Bitrise to configure de CI/CD pipelines.

## License

Flutter-Base is available under the MIT license. See the LICENSE file for more info.

**NOTE:** Remove the free LICENSE file for private projects or replace it with the corresponding license.

## Credits

**Flutter Base** is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/flutter-base/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
