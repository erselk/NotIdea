import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/friends/data/datasources/friends_remote_datasource.dart';
import 'package:notidea/features/friends/data/repositories/friends_repository_impl.dart';
import 'package:notidea/features/friends/domain/models/friendship_model.dart';
import 'package:notidea/features/friends/domain/repositories/friends_repository.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'friends_provider.g.dart';

@riverpod
FriendsRemoteDatasource friendsRemoteDatasource(
    FriendsRemoteDatasourceRef ref) {
  return FriendsRemoteDatasource();
}

@riverpod
FriendsRepository friendsRepository(FriendsRepositoryRef ref) {
  return FriendsRepositoryImpl(
    remoteDatasource: ref.watch(friendsRemoteDatasourceProvider),
  );
}

@riverpod
Future<List<FriendshipModel>> friendsList(FriendsListRef ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(friendsRepositoryProvider);
  return repository.getFriends(currentUser.id);
}

@riverpod
Future<List<FriendshipModel>> pendingRequests(PendingRequestsRef ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(friendsRepositoryProvider);
  return repository.getPendingRequests(currentUser.id);
}

@riverpod
class SendFriendRequest extends _$SendFriendRequest {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String addresseeId) async {
    final currentUser = await ref.read(currentUserProvider.future);
    if (currentUser == null) throw Exception('User not authenticated');

    final repository = ref.read(friendsRepositoryProvider);
    await repository.sendRequest(
      requesterId: currentUser.id,
      addresseeId: addresseeId,
    );
    ref.invalidate(pendingRequestsProvider);
    ref.invalidate(friendsListProvider);
  }
}

@riverpod
class AcceptFriendRequest extends _$AcceptFriendRequest {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String friendshipId) async {
    final repository = ref.read(friendsRepositoryProvider);
    await repository.acceptRequest(friendshipId);
    ref.invalidate(pendingRequestsProvider);
    ref.invalidate(friendsListProvider);
  }
}

@riverpod
class RejectFriendRequest extends _$RejectFriendRequest {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String friendshipId) async {
    final repository = ref.read(friendsRepositoryProvider);
    await repository.rejectRequest(friendshipId);
    ref.invalidate(pendingRequestsProvider);
  }
}

@riverpod
class RemoveFriend extends _$RemoveFriend {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String friendshipId) async {
    final repository = ref.read(friendsRepositoryProvider);
    await repository.removeFriend(friendshipId);
    ref.invalidate(friendsListProvider);
  }
}

@riverpod
Future<List<ProfileModel>> searchUsers(
  SearchUsersRef ref,
  String query,
) async {
  if (query.trim().length < 2) return [];

  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(friendsRepositoryProvider);
  return repository.searchUsers(
    query: query.trim(),
    currentUserId: currentUser.id,
  );
}
