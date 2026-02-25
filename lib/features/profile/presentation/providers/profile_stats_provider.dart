import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/friends/domain/models/friendship_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_stats_provider.g.dart';

class ProfileStats {
  final int noteCount;
  final int friendCount;
  final int groupCount;

  const ProfileStats({
    required this.noteCount,
    required this.friendCount,
    required this.groupCount,
  });
}

@riverpod
Future<ProfileStats> profileStats(Ref ref, String userId) async {
  final client = SupabaseConfig.client;

  try {
    // Fetch Notes dynamically
    final notesRes = await client
        .from('notes')
        .select('id')
        .eq('user_id', userId);

    final noteCount = (notesRes as List).length;

    // Fetch Friends dynamically
    final friendsRes = await client
        .from('friendships')
        .select('id')
        .or('requester_id.eq.$userId,addressee_id.eq.$userId')
        .eq('status', FriendshipStatus.accepted.value);

    final friendCount = (friendsRes as List).length;

    // Fetch Groups dynamically
    final groupsRes = await client
        .from('group_members')
        .select('id')
        .eq('user_id', userId);

    final groupCount = (groupsRes as List).length;

    return ProfileStats(
      noteCount: noteCount,
      friendCount: friendCount,
      groupCount: groupCount,
    );
  } catch (e) {
    // In case of any error, default to 0
    return const ProfileStats(noteCount: 0, friendCount: 0, groupCount: 0);
  }
}
