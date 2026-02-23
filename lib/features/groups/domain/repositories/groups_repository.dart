import 'package:notidea/features/groups/domain/models/group_member_model.dart';
import 'package:notidea/features/groups/domain/models/group_model.dart';

abstract class GroupsRepository {
  Future<List<GroupModel>> getMyGroups(String userId);

  Future<GroupModel?> getGroupById(String groupId);

  Future<GroupModel> createGroup({
    required String name,
    String? description,
    required String ownerId,
    List<String> memberIds = const [],
  });

  Future<GroupModel> updateGroup(GroupModel group);

  Future<void> deleteGroup(String groupId);

  Future<void> addMember({
    required String groupId,
    required String userId,
  });

  Future<void> removeMember({
    required String groupId,
    required String userId,
  });

  Future<List<GroupMemberModel>> getGroupMembers(String groupId);

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  });
}
