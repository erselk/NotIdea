import 'dart:typed_data';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/core/constants/storage_constants.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDatasource {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<ProfileModel?> getProfileById(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final data = {
      'username': profile.username,
      'display_name': profile.displayName,
      'avatar_url': profile.avatarUrl,
      'bio': profile.bio,
      'updated_at': DateTime.now().toIso8601String(),
    };

    final response = await _client
        .from('profiles')
        .update(data)
        .eq('id', profile.id)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<String> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final path = StorageConstants.avatarPath(userId);
    final fullPath = '$path.$fileExtension';

    await _client.storage.from(StorageConstants.avatarsBucket).uploadBinary(
          fullPath,
          bytes,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = _client.storage
        .from(StorageConstants.avatarsBucket)
        .getPublicUrl(fullPath);

    await _client.from('profiles').update({
      'avatar_url': publicUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return publicUrl;
  }

  Future<void> deleteAccount(String userId) async {
    await _client.from('notes').delete().eq('user_id', userId);
    await _client.from('profiles').delete().eq('id', userId);
    await SupabaseConfig.auth.admin.deleteUser(userId);
  }
}
