import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/core/database/app_database.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/groups/data/datasources/groups_remote_datasource.dart';
import 'package:notidea/features/groups/data/repositories/groups_repository_impl.dart';
import 'package:notidea/features/groups/domain/models/group_member_model.dart';
import 'package:notidea/features/groups/domain/models/group_model.dart';
import 'package:notidea/features/groups/domain/repositories/groups_repository.dart';

part 'groups_provider.g.dart';

@riverpod
GroupsRemoteDatasource groupsRemoteDatasource(
    Ref ref) {
  return GroupsRemoteDatasource();
}

@riverpod
GroupsRepository groupsRepository(Ref ref) {
  return GroupsRepositoryImpl(
    remoteDatasource: ref.watch(groupsRemoteDatasourceProvider),
  );
}

@riverpod
Future<List<GroupModel>> myGroups(Ref ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(groupsRepositoryProvider);
  try {
    final groups = await repository.getMyGroups(currentUser.id);
    await AppDatabase.instance.cacheGroups(
      currentUser.id,
      groups.map((g) => g.toJson()).toList(),
    );
    return groups;
  } catch (_) {
    final cached = AppDatabase.instance.getCachedGroups(currentUser.id);
    if (cached != null) {
      return cached.map((m) => GroupModel.fromJson(m)).toList();
    }
    rethrow;
  }
}

@riverpod
Future<GroupModel?> groupById(Ref ref, String groupId) async {
  final repository = ref.watch(groupsRepositoryProvider);
  return repository.getGroupById(groupId);
}

@riverpod
Future<List<GroupMemberModel>> groupMembers(
  Ref ref,
  String groupId,
) async {
  final repository = ref.watch(groupsRepositoryProvider);
  return repository.getGroupMembers(groupId);
}

@Riverpod(keepAlive: true)
class CreateGroup extends _$CreateGroup {
  @override
  FutureOr<void> build() {}

  Future<GroupModel?> execute({
    required String name,
    String? description,
    List<String> memberIds = const [],
  }) async {
    state = const AsyncLoading();
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) throw Exception('User not authenticated');

      final repository = ref.read(groupsRepositoryProvider);
      final created = await repository.createGroup(
        name: name,
        description: description,
        ownerId: currentUser.id,
        memberIds: memberIds,
      );
      ref.invalidate(myGroupsProvider);
      state = const AsyncData(null);
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
class UpdateGroup extends _$UpdateGroup {
  @override
  FutureOr<void> build() {}

  Future<GroupModel?> execute(GroupModel group) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(groupsRepositoryProvider);
      final updated = await repository.updateGroup(group);
      ref.invalidate(myGroupsProvider);
      ref.invalidate(groupByIdProvider(group.id));
      state = const AsyncData(null);
      return updated;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
class DeleteGroup extends _$DeleteGroup {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String groupId) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(groupsRepositoryProvider);
      await repository.deleteGroup(groupId);
      ref.invalidate(myGroupsProvider);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
class AddGroupMember extends _$AddGroupMember {
  @override
  FutureOr<void> build() {}

  Future<void> execute({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(groupsRepositoryProvider);
      await repository.addMember(groupId: groupId, userId: userId);
      ref.invalidate(groupMembersProvider(groupId));
      ref.invalidate(groupByIdProvider(groupId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
class RemoveGroupMember extends _$RemoveGroupMember {
  @override
  FutureOr<void> build() {}

  Future<void> execute({
    required String groupId,
    required String userId,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(groupsRepositoryProvider);
      await repository.removeMember(groupId: groupId, userId: userId);
      ref.invalidate(groupMembersProvider(groupId));
      ref.invalidate(groupByIdProvider(groupId));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
