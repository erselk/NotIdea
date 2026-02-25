import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/repositories/notes_repository.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';

part 'favorites_provider.g.dart';

@riverpod
Future<List<NoteModel>> favoriteNotes(Ref ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(notesRepositoryProvider);
  return repository.getUserNotes(
    userId: currentUser.id,
    filter: const NoteFilter(isFavorite: true),
  );
}
