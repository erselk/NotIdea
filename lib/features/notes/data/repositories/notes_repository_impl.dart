import 'package:notidea/features/notes/data/datasources/notes_local_datasource.dart';
import 'package:notidea/features/notes/data/datasources/notes_remote_datasource.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/repositories/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDatasource _remoteDatasource;
  final NotesLocalDatasource _localDatasource;

  NotesRepositoryImpl({
    NotesRemoteDatasource? remoteDatasource,
    NotesLocalDatasource? localDatasource,
  })  : _remoteDatasource = remoteDatasource ?? NotesRemoteDatasource(),
        _localDatasource = localDatasource ?? NotesLocalDatasource();

  @override
  Future<List<NoteModel>> getUserNotes({
    required String userId,
    NoteFilter filter = const NoteFilter(),
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final notes = await _remoteDatasource.getUserNotes(
        userId: userId,
        filter: filter,
        offset: offset,
        limit: limit,
      );
      await _localDatasource.cacheNotes(notes);
      return notes;
    } catch (_) {
      return _localDatasource.getCachedNotes(userId);
    }
  }

  @override
  Future<NoteModel?> getNoteById(String noteId) async {
    try {
      final note = await _remoteDatasource.getNoteById(noteId);
      if (note != null) {
        await _localDatasource.cacheNote(note);
      }
      return note;
    } catch (_) {
      return _localDatasource.getCachedNoteById(noteId);
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    final created = await _remoteDatasource.createNote(note);
    await _localDatasource.cacheNote(created);
    return created;
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    final updated = await _remoteDatasource.updateNote(note);
    await _localDatasource.cacheNote(updated);
    return updated;
  }

  @override
  Future<void> softDeleteNote(String noteId) async {
    await _remoteDatasource.softDeleteNote(noteId);
    await _localDatasource.deleteCachedNote(noteId);
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    await _remoteDatasource.permanentlyDeleteNote(noteId);
    await _localDatasource.deleteCachedNote(noteId);
  }

  @override
  Future<void> toggleFavorite(String noteId, bool isFavorite) async {
    await _remoteDatasource.toggleFavorite(noteId, isFavorite);
  }

  @override
  Future<void> togglePin(String noteId, bool isPinned) async {
    await _remoteDatasource.togglePin(noteId, isPinned);
  }

  @override
  Future<String> createShareLink({
    required String noteId,
    required String sharedByUserId,
    required String permission,
  }) async {
    return _remoteDatasource.createShareLink(
      noteId: noteId,
      sharedByUserId: sharedByUserId,
      permission: permission,
    );
  }

  @override
  Future<List<NoteModel>> searchNotes({
    required String userId,
    required String query,
    int limit = 50,
  }) async {
    try {
      return await _remoteDatasource.searchNotes(
        userId: userId,
        query: query,
        limit: limit,
      );
    } catch (_) {
      return _localDatasource.searchCachedNotes(
        userId: userId,
        query: query,
      );
    }
  }

  @override
  Future<List<NoteModel>> getPublicNotes({
    int offset = 0,
    int limit = 30,
  }) async {
    return _remoteDatasource.getPublicNotes(offset: offset, limit: limit);
  }

  @override
  Future<List<NoteModel>> getSharedNotes({
    required String userId,
    int offset = 0,
    int limit = 20,
  }) async {
    return _remoteDatasource.getSharedNotes(
      userId: userId,
      offset: offset,
      limit: limit,
    );
  }
}
