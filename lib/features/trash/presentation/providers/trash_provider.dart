import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';

part 'trash_provider.g.dart';

@riverpod
Future<List<NoteModel>> trashedNotes(TrashedNotesRef ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final client = SupabaseConfig.client;
  final response = await client
      .from('notes')
      .select()
      .eq('user_id', currentUser.id)
      .eq('is_deleted', true)
      .order('deleted_at', ascending: false);

  return (response as List)
      .map((json) => NoteModel.fromJson(json as Map<String, dynamic>))
      .toList();
}

@riverpod
class RestoreNote extends _$RestoreNote {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String noteId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final client = SupabaseConfig.client;
      await client.from('notes').update({
        'is_deleted': false,
        'deleted_at': null,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', noteId);
      ref.invalidate(trashedNotesProvider);
      ref.invalidate(userNotesProvider);
    });
  }
}

@riverpod
class PermanentlyDelete extends _$PermanentlyDelete {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String noteId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.permanentlyDeleteNote(noteId);
      ref.invalidate(trashedNotesProvider);
    });
  }
}

@riverpod
class EmptyTrash extends _$EmptyTrash {
  @override
  FutureOr<void> build() {}

  Future<void> execute() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) return;

      final client = SupabaseConfig.client;
      await client
          .from('notes')
          .delete()
          .eq('user_id', currentUser.id)
          .eq('is_deleted', true);
      ref.invalidate(trashedNotesProvider);
    });
  }
}
