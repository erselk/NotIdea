import 'package:notidea/features/update/data/datasources/app_version_remote_datasource.dart';
import 'package:notidea/features/update/domain/models/app_version_model.dart';
import 'package:notidea/features/update/domain/repositories/app_version_repository.dart';

class AppVersionRepositoryImpl implements AppVersionRepository {
  AppVersionRepositoryImpl({AppVersionRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? AppVersionRemoteDatasource();

  final AppVersionRemoteDatasource _remoteDatasource;

  @override
  Future<AppVersionModel?> getLatestForPlatform(String platform) {
    return _remoteDatasource.getLatestForPlatform(platform);
  }
}

