import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/repositories/notes_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesRemoteDatasource {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<NoteModel>> getUserNotes({
    required String userId,
    NoteFilter filter = const NoteFilter(),
    int offset = 0,
    int limit = 20,
  }) async {
    var query = _client
        .from('notes')
        .select()
        .eq('user_id', userId)
        .eq('is_deleted', false);

    if (filter.isFavorite != null) {
      query = query.eq('is_favorite', filter.isFavorite!);
    }

    if (filter.visibility != null) {
      query = query.eq('visibility', filter.visibility!.value);
    }

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      query = query.or(
        'title.ilike.%${filter.searchQuery}%,content.ilike.%${filter.searchQuery}%',
      );
    }

    final sortColumn = switch (filter.sortBy) {
      NoteSortBy.createdAt => 'created_at',
      NoteSortBy.updatedAt => 'updated_at',
      NoteSortBy.title => 'title',
    };

    final ascending = filter.sortOrder == NoteSortOrder.ascending;

    final response = await query
        .order('is_pinned', ascending: false)
        .order('pinned_at', ascending: false, nullsFirst: false)
        .order(sortColumn, ascending: ascending)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<NoteModel?> getNoteById(String noteId) async {
    final response = await _client
        .from('notes')
        .select()
        .eq('id', noteId)
        .maybeSingle();

    if (response == null) return null;
    return NoteModel.fromJson(response);
  }

  Future<NoteModel> createNote(NoteModel note) async {
    final data = note.toJson();
    data.remove('pinned_at');
    data.remove('deleted_at');

    final response = await _client
        .from('notes')
        .insert(data)
        .select()
        .single();

    return NoteModel.fromJson(response);
  }

  Future<NoteModel> updateNote(NoteModel note) async {
    final data = note.copyWith(updatedAt: DateTime.now()).toJson();
    data.remove('id');
    data.remove('user_id');
    data.remove('created_at');

    final response = await _client
        .from('notes')
        .update(data)
        .eq('id', note.id)
        .select()
        .single();

    return NoteModel.fromJson(response);
  }

  Future<void> softDeleteNote(String noteId) async {
    await _client.from('notes').update({
      'is_deleted': true,
      'deleted_at': DateTime.now().toIso8601String(),
    }).eq('id', noteId);
  }

  Future<void> permanentlyDeleteNote(String noteId) async {
    await _client.from('notes').delete().eq('id', noteId);
  }

  Future<void> toggleFavorite(String noteId, bool isFavorite) async {
    await _client.from('notes').update({
      'is_favorite': isFavorite,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', noteId);
  }

  Future<void> togglePin(String noteId, bool isPinned) async {
    await _client.from('notes').update({
      'is_pinned': isPinned,
      'pinned_at': isPinned ? DateTime.now().toIso8601String() : null,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', noteId);
  }

  Future<String> createShareLink({
    required String noteId,
    required String sharedByUserId,
    required String permission,
  }) async {
    final token = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    await _client.from('note_shares').insert({
      'note_id': noteId,
      'shared_by_user_id': sharedByUserId,
      'share_token': token,
      'permission': permission,
      'created_at': DateTime.now().toIso8601String(),
    });
    return token;
  }

  Future<List<NoteModel>> searchNotes({
    required String userId,
    required String query,
    int limit = 50,
  }) async {
    final response = await _client
        .from('notes')
        .select()
        .eq('user_id', userId)
        .eq('is_deleted', false)
        .or('title.ilike.%$query%,content.ilike.%$query%')
        .order('updated_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<NoteModel>> getPublicNotes({
    int offset = 0,
    int limit = 30,
  }) async {
    final response = await _client
        .from('notes')
        .select()
        .eq('visibility', 'public')
        .eq('is_deleted', false)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<NoteModel>> getSharedNotes({
    required String userId,
    int offset = 0,
    int limit = 20,
  }) async {
    final response = await _client
        .from('note_shares')
        .select('note:notes(*)')
        .eq('shared_with_user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .where((r) => r['note'] != null)
        .map((r) => NoteModel.fromJson(r['note'] as Map<String, dynamic>))
        .toList();
  }
}
