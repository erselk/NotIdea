import 'package:notidea/features/groups/data/datasources/groups_remote_datasource.dart';
import 'package:notidea/features/groups/domain/models/group_member_model.dart';
import 'package:notidea/features/groups/domain/models/group_model.dart';
import 'package:notidea/features/groups/domain/repositories/groups_repository.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDatasource _remoteDatasource;

  GroupsRepositoryImpl({GroupsRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? GroupsRemoteDatasource();

  @override
  Future<List<GroupModel>> getMyGroups(String userId) {
    return _remoteDatasource.getMyGroups(userId);
  }

  @override
  Future<GroupModel?> getGroupById(String groupId) {
    return _remoteDatasource.getGroupById(groupId);
  }

  @override
  Future<GroupModel> createGroup({
    required String name,
    String? description,
    required String ownerId,
    List<String> memberIds = const [],
  }) {
    return _remoteDatasource.createGroup(
      name: name,
      description: description,
      ownerId: ownerId,
      memberIds: memberIds,
    );
  }

  @override
  Future<GroupModel> updateGroup(GroupModel group) {
    return _remoteDatasource.updateGroup(group);
  }

  @override
  Future<void> deleteGroup(String groupId) {
    return _remoteDatasource.deleteGroup(groupId);
  }

  @override
  Future<void> addMember({
    required String groupId,
    required String userId,
  }) {
    return _remoteDatasource.addMember(groupId: groupId, userId: userId);
  }

  @override
  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) {
    return _remoteDatasource.removeMember(groupId: groupId, userId: userId);
  }

  @override
  Future<List<GroupMemberModel>> getGroupMembers(String groupId) {
    return _remoteDatasource.getGroupMembers(groupId);
  }

  @override
  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) {
    return _remoteDatasource.leaveGroup(groupId: groupId, userId: userId);
  }
}
