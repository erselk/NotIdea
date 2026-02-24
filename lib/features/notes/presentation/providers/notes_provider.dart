import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:notidea/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:notidea/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/repositories/notes_repository.dart';

part 'notes_provider.g.dart';

@riverpod
NotesRemoteDatasource notesRemoteDatasource(NotesRemoteDatasourceRef ref) {
  return NotesRemoteDatasource();
}

@riverpod
NotesLocalDatasource notesLocalDatasource(NotesLocalDatasourceRef ref) {
  return NotesLocalDatasource();
}

@riverpod
NotesRepository notesRepository(NotesRepositoryRef ref) {
  return NotesRepositoryImpl(
    remoteDatasource: ref.watch(notesRemoteDatasourceProvider),
    localDatasource: ref.watch(notesLocalDatasourceProvider),
  );
}

@riverpod
class NoteFilterNotifier extends _$NoteFilterNotifier {
  @override
  NoteFilter build() => const NoteFilter();

  void setSortBy(NoteSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void setSortOrder(NoteSortOrder order) {
    state = state.copyWith(sortOrder: order);
  }

  void setFavoriteFilter(bool? isFavorite) {
    state = state.copyWith(isFavorite: isFavorite);
  }

  void setVisibilityFilter(dynamic visibility) {
    state = state.copyWith(visibility: visibility);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void reset() {
    state = const NoteFilter();
  }
}

@riverpod
Future<List<NoteModel>> userNotes(UserNotesRef ref) async {
  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final filter = ref.watch(noteFilterNotifierProvider);
  final repository = ref.watch(notesRepositoryProvider);

  return repository.getUserNotes(
    userId: currentUser.id,
    filter: filter,
  );
}

@riverpod
Future<NoteModel?> noteById(NoteByIdRef ref, String noteId) async {
  final repository = ref.watch(notesRepositoryProvider);
  return repository.getNoteById(noteId);
}

@riverpod
class CreateNote extends _$CreateNote {
  @override
  FutureOr<void> build() {}

  Future<NoteModel> execute(NoteModel note) async {
    final repository = ref.read(notesRepositoryProvider);
    final created = await repository.createNote(note);
    ref.invalidate(userNotesProvider);
    return created;
  }
}

@riverpod
class UpdateNote extends _$UpdateNote {
  @override
  FutureOr<void> build() {}

  Future<NoteModel> execute(NoteModel note) async {
    final repository = ref.read(notesRepositoryProvider);
    final updated = await repository.updateNote(note);
    ref.invalidate(userNotesProvider);
    ref.invalidate(noteByIdProvider(note.id));
    return updated;
  }
}

@riverpod
class DeleteNote extends _$DeleteNote {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String noteId) async {
    final repository = ref.read(notesRepositoryProvider);
    await repository.softDeleteNote(noteId);
    ref.invalidate(userNotesProvider);
  }
}

@riverpod
class ToggleFavorite extends _$ToggleFavorite {
  @override
  FutureOr<void> build() {}

  Future<void> execute(String noteId, bool isFavorite) async {
    final repository = ref.read(notesRepositoryProvider);
    await repository.toggleFavorite(noteId, isFavorite);
    ref.invalidate(userNotesProvider);
    ref.invalidate(noteByIdProvider(noteId));
  }
}

@riverpod
Future<List<NoteModel>> noteSearch(
  NoteSearchRef ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(notesRepositoryProvider);
  return repository.searchNotes(
    userId: currentUser.id,
    query: query,
  );
}
