# DEalog mobile

This is the mobile app for the DEalog project.

## Prerequisites

- Flutter 1.20.0
- Dart 2.9.0
- Xcode 11.5
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

Alternatively you can use the VScode Flutter plugin. Note that you need to
install the Android SDK manually then.

### i18n & l10n

For translation and localization we use the [Easy Localization](https://pub.dev/packages/easy_localization) plugin.

### Theming

The application supports dark mode via Flutter's embedded support.

### Testing
Testing is done on all 3 levels that are supported by the [flutter framework](https://flutter.dev/docs/testing)

#### Unit
For unit tests we use [mockito](https://pub.dev/packages/mockito) to mock dynamic data. Complex functions/computations are tested here. This tests are executed within the framework itself and are very fast.

#### Widget
Widget tests cover the UI behavior for a dedicated widget. It allows us to develop test driven. This tests are executed within the framework itself and are very fast.
#### Integration
Integration tests allows to test a whole app, so the interaction between multiple widgets. The integration tests are executed in a platform emulator e.g. Android(AVD) so they need more time because the test needs a started emulator and needs to flash the app on the virtual device.

#### Test Execution
- Unit and widget tests will be executed by the "flutter test" command within the app root directory.
- Integration tests will be executed by the "flutter drive --target=test_driver/app.dart" command within the app root directory. This example tests the main app, anyway there could be more Integration tests to test certain widget groupings 

### Logging
For extensible logging we use [fimber](https://pub.dev/packages/fimber) package.