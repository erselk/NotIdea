import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/friends/domain/models/friendship_model.dart';
import 'package:notidea/features/friends/domain/models/friendship_status.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsRemoteDatasource {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<FriendshipModel>> getFriends(String userId) async {
    final response = await _client
        .from('friendships')
        .select('''
          *,
          requester_profile:profiles!requester_id(*),
          addressee_profile:profiles!addressee_id(*)
        ''')
        .or('requester_id.eq.$userId,addressee_id.eq.$userId')
        .eq('status', FriendshipStatus.accepted.value);

    return (response as List).map((json) {
      final map = json as Map<String, dynamic>;
      final requesterProfile = map.remove('requester_profile');
      final addresseeProfile = map.remove('addressee_profile');
      return FriendshipModel.fromJson(map).copyWith(
        requesterProfile: requesterProfile != null
            ? ProfileModel.fromJson(requesterProfile as Map<String, dynamic>)
            : null,
        addresseeProfile: addresseeProfile != null
            ? ProfileModel.fromJson(addresseeProfile as Map<String, dynamic>)
            : null,
      );
    }).toList();
  }

  Future<List<FriendshipModel>> getPendingRequests(String userId) async {
    final incoming = await _client
        .from('friendships')
        .select('*, requester_profile:profiles!requester_id(*)')
        .eq('addressee_id', userId)
        .eq('status', FriendshipStatus.pending.value)
        .order('created_at', ascending: false);

    final outgoing = await _client
        .from('friendships')
        .select('*, addressee_profile:profiles!addressee_id(*)')
        .eq('requester_id', userId)
        .eq('status', FriendshipStatus.pending.value)
        .order('created_at', ascending: false);

    final results = <FriendshipModel>[];

    for (final json in incoming as List) {
      final map = json as Map<String, dynamic>;
      final requesterProfile = map.remove('requester_profile');
      final model = FriendshipModel.fromJson(map).copyWith(
        requesterProfile: requesterProfile != null
            ? ProfileModel.fromJson(requesterProfile as Map<String, dynamic>)
            : null,
      );
      results.add(model);
    }

    for (final json in outgoing as List) {
      final map = json as Map<String, dynamic>;
      final addresseeProfile = map.remove('addressee_profile');
      final model = FriendshipModel.fromJson(map).copyWith(
        addresseeProfile: addresseeProfile != null
            ? ProfileModel.fromJson(addresseeProfile as Map<String, dynamic>)
            : null,
      );
      results.add(model);
    }

    return results;
  }

  Future<FriendshipModel> sendRequest({
    required String requesterId,
    required String addresseeId,
  }) async {
    final response = await _client
        .from('friendships')
        .insert({
          'requester_id': requesterId,
          'addressee_id': addresseeId,
          'status': FriendshipStatus.pending.value,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return FriendshipModel.fromJson(response);
  }

  Future<void> acceptRequest(String friendshipId) async {
    await _client.from('friendships').update({
      'status': FriendshipStatus.accepted.value,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', friendshipId);
  }

  Future<void> rejectRequest(String friendshipId) async {
    await _client.from('friendships').update({
      'status': FriendshipStatus.rejected.value,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', friendshipId);
  }

  Future<void> removeFriend(String friendshipId) async {
    await _client.from('friendships').delete().eq('id', friendshipId);
  }

  Future<void> blockUser({
    required String userId,
    required String blockedUserId,
  }) async {
    final existing = await _client
        .from('friendships')
        .select()
        .or('and(requester_id.eq.$userId,addressee_id.eq.$blockedUserId),and(requester_id.eq.$blockedUserId,addressee_id.eq.$userId)')
        .maybeSingle();

    if (existing != null) {
      await _client.from('friendships').update({
        'status': FriendshipStatus.blocked.value,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', existing['id']);
    } else {
      await _client.from('friendships').insert({
        'requester_id': userId,
        'addressee_id': blockedUserId,
        'status': FriendshipStatus.blocked.value,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<ProfileModel>> searchUsers({
    required String query,
    required String currentUserId,
    int limit = 20,
  }) async {
    final response = await _client
        .from('profiles')
        .select()
        .neq('id', currentUserId)
        .or('username.ilike.%$query%,display_name.ilike.%$query%')
        .limit(limit);

    return (response as List)
        .map((json) => ProfileModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
