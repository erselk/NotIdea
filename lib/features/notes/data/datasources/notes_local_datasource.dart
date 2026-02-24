import 'package:notidea/core/database/app_database.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';

class NotesLocalDatasource {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> cacheNotes(List<NoteModel> notes) => _db.cacheNotes(notes);

  Future<void> cacheNote(NoteModel note) => _db.cacheNote(note);

  Future<List<NoteModel>> getCachedNotes(String userId) async {
    return _db.getNotesByUserId(userId);
  }

  Future<NoteModel?> getCachedNoteById(String noteId) async {
    return _db.getNoteById(noteId);
  }

  Future<List<NoteModel>> searchCachedNotes({
    required String userId,
    required String query,
  }) async {
    return _db.searchNotes(userId, query);
  }

  Future<void> deleteCachedNote(String noteId) => _db.deleteNote(noteId);

  Future<void> clearCache() => _db.clearNotesCache();

  Future<List<String>> getRecentSearches({int limit = 10}) async {
    return _db.getRecentSearches(limit: limit);
  }

  Future<void> addSearchQuery(String query) => _db.addSearch(query);

  Future<void> clearSearchHistory() => _db.clearSearchHistory();
}
