import 'package:notidea/features/update/domain/models/app_version_model.dart';

abstract class AppVersionRepository {
  Future<AppVersionModel?> getLatestForPlatform(String platform);
}

