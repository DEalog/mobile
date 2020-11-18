import 'package:get_it/get_it.dart';
import 'package:mobile/api/feed_service.dart';
import 'package:mobile/api/rest_client.dart';
import 'package:mobile/api/serializer.dart';
import 'package:mobile/app_settings.dart';
import 'package:mobile/version.dart';
import 'package:package_info/package_info.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

void register(GetIt getIt) {
  getIt.registerSingletonAsync(() => StreamingSharedPreferences.instance);

  getIt.registerSingletonAsync(() => PackageInfo.fromPlatform());

  getIt.registerSingleton(Serializer());

  getIt.registerSingleton(RestClient());

  getIt.registerSingleton(FeedService());

  getIt.registerSingletonWithDependencies(
      () => AppSettings(getIt<StreamingSharedPreferences>()),
      dependsOn: [StreamingSharedPreferences]);

  getIt.registerSingletonWithDependencies(
      () => Version(getIt<AppSettings>(), getIt<PackageInfo>()),
      dependsOn: [AppSettings, PackageInfo]);
}
