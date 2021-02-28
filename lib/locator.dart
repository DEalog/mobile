import 'package:get_it/get_it.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/api/location_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/app_settings.dart';
import 'package:mobile/version.dart';
import 'package:package_info/package_info.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void register(GetIt getIt) {
  getIt.registerSingletonAsync(() => StreamingSharedPreferences.instance);

  getIt.registerSingletonAsync(() => PackageInfo.fromPlatform());

  getIt.registerSingletonAsync<RestClient>(() async => RestClient());

  getIt.registerSingletonAsync<LocationService>(() async => LocationService());

  getIt.registerSingletonWithDependencies(
    () => DataService(),
    dependsOn: [RestClient],
  );

  getIt.registerSingletonWithDependencies(
    () => AppSettings(getIt<StreamingSharedPreferences>()),
    dependsOn: [StreamingSharedPreferences],
  );

  getIt.registerSingletonWithDependencies(
    () => Version(getIt<AppSettings>(), getIt<PackageInfo>()),
    dependsOn: [AppSettings, PackageInfo],
  );
}
