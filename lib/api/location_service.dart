import 'package:fimber/fimber.dart';
import 'package:location/location.dart';

class LocationService {
  Future<LocationData> getLocationFromDevice() async {
    const testEnvironment = String.fromEnvironment(
      'FLUTTER_TEST_ENVIRONMENT',
      defaultValue: 'None',
    );
    if (testEnvironment == 'int') {
      Fimber.i(
        "Flutter Test Env $testEnvironment is set. Use static location 52.1, 11.1 for testing",
      );
      return LocationData.fromMap(
        {
          'latitude': 52.1,
          'longitude': 11.1,
          'accuracy': 0.0,
          'altitude': 0.0,
          'speed': 0.0,
          'speed_accuracy': 0.0,
          'heading': 0.0,
          'time': 0.0,
        },
      );
    } else {
      Location location = Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return throw ("Service couldn't be enabled.");
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return throw ("Permission couldn't be granted.");
        }
      }
      return location.getLocation();
    }
  }
}
