import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/groups/data/datasources/groups_remote_datasource.dart';
import 'package:notidea/features/groups/data/repositories/groups_repository_impl.dart';
import 'package:notidea/features/groups/domain/models/group_member_model.dart';
import 'package:notidea/features/groups/domain/models/group_model.dart';
import 'package:notidea/features/groups/domain/repositories/groups_repository.dart';

part 'groups_provider.g.dart';

@riverpod
GroupsRemoteDatasource groupsRemoteDatasource(
    GroupsRemoteDatasourceRef ref) {
  return GroupsRemoteDatasource();
}

@riverpod
GroupsRepository groupsRepository(GroupsRepositoryRef ref) {
  return GroupsRepositoryImpl(
    remoteDatasource: ref.watch(groupsRemoteDatasourceProvider),
  );
}

@riverpod
Future<List<GroupModel>> myGroups(MyGroupsRef ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(groupsRepositoryProvider);
  return repository.getMyGroups(currentUser.id);
}

@riverpod
Future<GroupModel?> groupById(GroupByIdRef ref, String groupId) async {
  final repository = ref.watch(groupsRepositoryProvider);
  return repository.getGroupById(groupId);
}

@riverpod
Future<List<GroupMemberModel>> groupMembers(
  GroupMembersRef ref,
  String groupId,
) async {
  final repository = ref.watch(groupsRepositoryProvider);
  return repository.getGroupMembers(groupId);
}

@riverpod
class CreateGroup extends _$CreateGroup {
  @override
  FutureOr<void> build() {}

  Future<GroupModel?> execute({
    required String name,
    String? description,
    List<String> memberIds = const [],
  }) async {
    GroupModel? created;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) throw Exception('User not authenticated');

      final repository = ref.read(groupsRepositoryProvider);
      created = await repository.createGroup(
        name: name,
        description: description,
        ownerId: currentUser.id,
        memberIds: memberIds,
      );
      ref.invalidate(myGroupsProvider);
    });
    return created;
  }
}

@riverpod
class UpdateGroup extends _$UpdateGroup {
  @override
  FutureOr<void> build() {}

  Future<GroupModel?> execute(GroupModel group) async {
    GroupModel? updated;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupsRepositoryProvider);
      updated = await repository.updateGroup(group);
      ref.invalidate(myGroupsProvider);
      ref.invalidate(groupByIdProvider(group.id));
    });
    return updated;
  }
}

@riverpod
class DeleteGroup extends _$DeleteGroup {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String groupId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupsRepositoryProvider);
      await repository.deleteGroup(groupId);
      ref.invalidate(myGroupsProvider);
    });
  }
}

@riverpod
class AddGroupMember extends _$AddGroupMember {
  @override
  FutureOr<void> build() {}

  Future<void> execute({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupsRepositoryProvider);
      await repository.addMember(groupId: groupId, userId: userId);
      ref.invalidate(groupMembersProvider(groupId));
      ref.invalidate(groupByIdProvider(groupId));
    });
  }
}

@riverpod
class RemoveGroupMember extends _$RemoveGroupMember {
  @override
  FutureOr<void> build() {}

  Future<void> execute({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(groupsRepositoryProvider);
      await repository.removeMember(groupId: groupId, userId: userId);
      ref.invalidate(groupMembersProvider(groupId));
      ref.invalidate(groupByIdProvider(groupId));
    });
  }
}
