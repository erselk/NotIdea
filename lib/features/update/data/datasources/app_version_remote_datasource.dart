import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/update/domain/models/app_version_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppVersionRemoteDatasource {
  AppVersionRemoteDatasource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  Future<AppVersionModel?> getLatestForPlatform(String platform) async {
    final data = await _client
        .from('app_versions')
        .select()
        .eq('platform', platform)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return null;
    return AppVersionModel.fromJson(data);
  }
}

