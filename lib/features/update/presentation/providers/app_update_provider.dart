import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/update/data/datasources/app_version_remote_datasource.dart';
import 'package:notidea/features/update/data/repositories/app_version_repository_impl.dart';
import 'package:notidea/features/update/domain/models/app_version_model.dart';
import 'package:notidea/features/update/domain/repositories/app_version_repository.dart';

part 'app_update_provider.g.dart';

@riverpod
AppVersionRemoteDatasource appVersionRemoteDatasource(Ref ref) {
  return AppVersionRemoteDatasource();
}

@riverpod
AppVersionRepository appVersionRepository(Ref ref) {
  final datasource = ref.watch(appVersionRemoteDatasourceProvider);
  return AppVersionRepositoryImpl(remoteDatasource: datasource);
}

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.currentVersion,
    required this.latest,
    required this.isUpdateAvailable,
    required this.isForced,
  });

  final String currentVersion;
  final AppVersionModel latest;
  final bool isUpdateAvailable;
  final bool isForced;
}

String _detectPlatform() {
  if (kIsWeb) return 'web';
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'android';
    default:
      return 'android';
  }
}

int _compareVersion(String a, String b) {
  List<int> parse(String v) =>
      v.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  final pa = parse(a);
  final pb = parse(b);
  final maxLen = pa.length > pb.length ? pa.length : pb.length;

  for (var i = 0; i < maxLen; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va.compareTo(vb);
  }
  return 0;
}

@riverpod
Future<AppUpdateInfo?> checkAppUpdate(Ref ref) async {
  final platform = _detectPlatform();

  // Şimdilik sadece Android için kontrol et.
  if (platform != 'android') return null;

  final repository = ref.watch(appVersionRepositoryProvider);
  final latest = await repository.getLatestForPlatform(platform);
  if (latest == null) return null;

  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final cmpLatest = _compareVersion(currentVersion, latest.version);
  if (cmpLatest >= 0) {
    return null;
  }

  final cmpMin = _compareVersion(currentVersion, latest.minSupportedVersion);
  final isForced = cmpMin < 0 || latest.forceUpdate;

  return AppUpdateInfo(
    currentVersion: currentVersion,
    latest: latest,
    isUpdateAvailable: true,
    isForced: isForced,
  );
}

