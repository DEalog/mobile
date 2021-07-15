[![Build Status](https://app.bitrise.io/app/e1572c13734b4305/status.svg?token=L2hi96aZiyJMveEO2iu_dA&branch=master)](https://app.bitrise.io/app/e1572c13734b4305)

# DEalog mobile

This is the mobile app for the DEalog project.

## Prerequisites

- Flutter 2.2.3
- Dart 2.13.4
- Xcode 12.4
- Android SDK 30.0.3

## Development

In order to support the development you need to first setup your development
environment appropriately.

Please see the [Flutter documentation](https://flutter.dev) on how to do so.

In order to be able to run the iOS version you need to develop on a macOS system.

Android works on every major platform.

### Editors

Flutter has broad support on various platforms. The easiest solution is to use
Android Studio with the Flutter plugin.

Alternatively you can use the VS Code Flutter plugin. Note that you need to
install the Android SDK manually then.

### Json Serializer

For json serialization we are using [json_serializable](https://pub.dev/packages/json_serializable).

* One-time code generation
  ```flutter pub run build_runner build --delete-conflicting-outputs```
* Generating code continuously
  ```
  flutter pub run build_runner watch
  ``` 

### i18n & l10n

For translation and localization we use the [Easy Localization](https://pub.dev/packages/easy_localization) plugin.

Regenerate configuration:
```shell script
flutter pub run easy_localization:generate -S ./assets/translations   
```

Regenerate key classes:
```shell script
flutter pub run easy_localization:generate -S ./assets/translations -f keys -o locale_keys.g.dart
```

### Theming

The application supports dark mode via Flutter's embedded support.

### App Icons

To simplify the generation of app icons for iOS and Android, we use the [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) plugin.

If the app icons are changed within the asset directory, you have to run
```shell script
flutter pub run flutter_launcher_icons:main
```
to update the icons in the iOS and Android project.

### Platform Abstraction

We use [Platform Widgets](https://pub.dev/packages/flutter_platform_widgets) to simplify the codebase regading the platform specific styles (Material for Android devices and Cupertino for iOS devices).

### Service Locator

We use [get_it](https://pub.dev/packages/get_it) as a service locator (a simple dependency injection mechanism) to define how to create  objects with all their dependencies. The definitions can be found in the `lib/locator.dart` source file.

### Testing

Testing is done on all 3 levels that are supported by the [flutter framework](https://flutter.dev/docs/testing)

#### Unit

For unit tests we use [mockito](https://pub.dev/packages/mockito) to mock dynamic data. Complex functions/computations are tested here. These tests are executed within the framework itself and are very fast.

#### Widget

Widget tests cover the UI behavior for a dedicated widget. It allows us to develop test driven. This tests are executed within the framework itself and are very fast.

#### Integration

Integration tests allows to test a whole app, so the interaction between multiple widgets. The integration tests are executed in a platform emulator e.g. Android(AVD) so they need more time because the test needs a started emulator and needs to flash the app on the virtual device.

#### Test Execution

- Unit and widget tests will be executed by the following command within the app root directory.
  ```
  flutter test
  ``` 
- Integration tests will be executed by the following command within the app root directory. This example tests the main app, anyway there could be more Integration tests to test certain widget groupings 
  ```
  flutter drive --dart-define=FLUTTER_TEST_ENVIRONMENT=int --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
  ``` 


#### Best Practices

- When testing a widget that is using ```StreamingSharedPreferences``` make sure the underlaying ```Shared.Preferences``` are initially mocked with ```SharedPreferences.setMockInitialValues```.

### Logging

For extensible logging we use [fimber](https://pub.dev/packages/fimber) package.

## Create builds

  * Android App Bundle:
    ```shell script
    flutter build appbundle
    ```
### Build

The Bitrise workflows can be executed locally. E. g. nstall the bitrise CLI executable and run:

```
bitrise run <workflow name>
```

To provide the secrets for the build, create a file `.bitrise.secrets.yml` with the following content:

```
envs:
- BITRISEIO_ANDROID_KEYSTORE_URL: file://<path to keystore>
- BITRISEIO_ANDROID_KEYSTORE_ALIAS: key
- BITRISEIO_ANDROID_KEYSTORE_PASSWORD: <keystore password>
- BITRISEIO_BITRISEIO_SERVICE_ACCOUNT_JSON_KEY_URL: file://<path to google play service account 
- SLACK_WEBHOOK_URL: <stlack webhook url>
```

### Release for pipeline

1. Increase the project version within the pubspec.yaml
1. Commit and push the repo with the updated project version
1. Create a new tag for the new project version