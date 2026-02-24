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

  Future<bool> isUsernameTaken(String username, {String? excludeUserId}) async {
    var query = _client
        .from('profiles')
        .select('id')
        .eq('username', username.toLowerCase());

    if (excludeUserId != null) {
      query = query.neq('id', excludeUserId);
    }

    final response = await query.maybeSingle();
    return response != null;
  }

  Future<ProfileModel> createProfile(ProfileModel profile) async {
    final taken = await isUsernameTaken(profile.username);
    if (taken) {
      throw Exception('Username is already taken');
    }

    final now = DateTime.now();
    final data = profile.copyWith(createdAt: now, updatedAt: now).toJson();

    final response = await _client
        .from('profiles')
        .upsert(data)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    final taken = await isUsernameTaken(
      profile.username,
      excludeUserId: profile.id,
    );
    if (taken) {
      throw Exception('Username is already taken');
    }

    final data = profile.copyWith(updatedAt: DateTime.now()).toJson();
    data.remove('id');
    data.remove('created_at');

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

    final mimeType = switch (fileExtension) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };

    await _client.storage.from(StorageConstants.avatarsBucket).uploadBinary(
          fullPath,
          bytes,
          fileOptions: FileOptions(upsert: true, contentType: mimeType),
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
