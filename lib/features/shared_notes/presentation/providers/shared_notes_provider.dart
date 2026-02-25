import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_share_model.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'shared_notes_provider.g.dart';

@riverpod
Future<List<NoteShareModel>> sharedWithMeNotes(
    Ref ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final client = SupabaseConfig.client;

  final directShares = await client
      .from('note_shares')
      .select('*, note:notes(*), shared_by:profiles!note_shares_shared_by_user_id_fkey(*)')
      .eq('shared_with_user_id', currentUser.id)
      .order('created_at', ascending: false);

  final groupMemberships = await client
      .from('group_members')
      .select('group_id')
      .eq('user_id', currentUser.id);

  final groupIds = (groupMemberships as List)
      .map((r) => r['group_id'] as String)
      .toList();

  List<dynamic> groupShares = [];
  if (groupIds.isNotEmpty) {
    groupShares = await client
        .from('note_shares')
        .select('*, note:notes(*), shared_by:profiles!note_shares_shared_by_user_id_fkey(*)')
        .inFilter('shared_with_group_id', groupIds)
        .order('created_at', ascending: false);
  }

  final allShares = <NoteShareModel>[];

  for (final json in [...(directShares as List), ...groupShares]) {
    final map = json as Map<String, dynamic>;
    final noteData = map.remove('note');
    final sharedByData = map.remove('shared_by');

    var model = NoteShareModel.fromJson(map);
    if (noteData != null) {
      model = model.copyWith(
        note: NoteModel.fromJson(noteData as Map<String, dynamic>),
      );
    }
    if (sharedByData != null) {
      model = model.copyWith(
        sharedByProfile:
            ProfileModel.fromJson(sharedByData as Map<String, dynamic>),
      );
    }
    allShares.add(model);
  }

  final seen = <String>{};
  return allShares.where((s) => seen.add(s.noteId)).toList();
}
