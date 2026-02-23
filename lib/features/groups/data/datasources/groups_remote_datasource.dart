import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/groups/domain/models/group_member_model.dart';
import 'package:notidea/features/groups/domain/models/group_member_role.dart';
import 'package:notidea/features/groups/domain/models/group_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupsRemoteDatasource {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<GroupModel>> getMyGroups(String userId) async {
    final memberRows = await _client
        .from('group_members')
        .select('group_id')
        .eq('user_id', userId);

    final groupIds =
        (memberRows as List).map((r) => r['group_id'] as String).toList();

    if (groupIds.isEmpty) return [];

    final response = await _client
        .from('groups')
        .select()
        .inFilter('id', groupIds)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<GroupModel?> getGroupById(String groupId) async {
    final response = await _client
        .from('groups')
        .select()
        .eq('id', groupId)
        .maybeSingle();

    if (response == null) return null;
    return GroupModel.fromJson(response);
  }

  Future<GroupModel> createGroup({
    required String name,
    String? description,
    required String ownerId,
    List<String> memberIds = const [],
  }) async {
    final now = DateTime.now().toIso8601String();

    final groupResponse = await _client
        .from('groups')
        .insert({
          'name': name,
          'description': description,
          'owner_id': ownerId,
          'member_count': memberIds.length + 1,
          'created_at': now,
        })
        .select()
        .single();

    final group = GroupModel.fromJson(groupResponse);

    await _client.from('group_members').insert({
      'group_id': group.id,
      'user_id': ownerId,
      'role': GroupMemberRole.owner.value,
      'joined_at': now,
    });

    for (final memberId in memberIds) {
      await _client.from('group_members').insert({
        'group_id': group.id,
        'user_id': memberId,
        'role': GroupMemberRole.member.value,
        'joined_at': now,
      });
    }

    return group;
  }

  Future<GroupModel> updateGroup(GroupModel group) async {
    final response = await _client
        .from('groups')
        .update({
          'name': group.name,
          'description': group.description,
          'avatar_url': group.avatarUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', group.id)
        .select()
        .single();

    return GroupModel.fromJson(response);
  }

  Future<void> deleteGroup(String groupId) async {
    await _client.from('group_members').delete().eq('group_id', groupId);
    await _client.from('groups').delete().eq('id', groupId);
  }

  Future<void> addMember({
    required String groupId,
    required String userId,
  }) async {
    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
      'role': GroupMemberRole.member.value,
      'joined_at': DateTime.now().toIso8601String(),
    });

    await _client.rpc('increment_group_member_count', params: {
      'p_group_id': groupId,
    });
  }

  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    await _client
        .from('group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId);

    await _client.rpc('decrement_group_member_count', params: {
      'p_group_id': groupId,
    });
  }

  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    final response = await _client
        .from('group_members')
        .select('*, profile:profiles(*)')
        .eq('group_id', groupId)
        .order('joined_at', ascending: true);

    return (response as List).map((json) {
      final map = json as Map<String, dynamic>;
      final profileData = map.remove('profile');
      final member = GroupMemberModel.fromJson(map);
      if (profileData != null) {
        return member.copyWith(
          profile: ProfileModel.fromJson(profileData as Map<String, dynamic>),
        );
      }
      return member;
    }).toList();
  }

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    await removeMember(groupId: groupId, userId: userId);
  }
}
