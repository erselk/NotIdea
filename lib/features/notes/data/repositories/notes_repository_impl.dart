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
      final remoteNotes = await _remoteDatasource.getUserNotes(
        userId: userId,
        filter: filter,
        offset: offset,
        limit: limit,
      );
      
      final localNotes = await _localDatasource.getCachedNotes(userId);
      final remoteNotesMap = {for (var n in remoteNotes) n.id: n};
      
      // Senkronizasyon: Lokaldeki not daha yeniyse veya uzakta yoksa uzaya gönder
      for (final local in localNotes) {
        final remote = remoteNotesMap[local.id];
        if (remote == null) {
          // Uzakta yok, oluştur
          try {
            if (!local.isDeleted) {
              await _remoteDatasource.createNote(local);
            }
          } catch (_) {}
        } else if (local.updatedAt.isAfter(remote.updatedAt)) {
          // Lokal daha yeni, güncelle
          try {
            await _remoteDatasource.updateNote(local);
          } catch (_) {}
        }
      }

      // Senkronizasyon sonrası yeniden çek veya şimdilik cache'i remote ile güncelle
      final updatedRemoteNotes = await _remoteDatasource.getUserNotes(
        userId: userId,
        filter: filter,
        offset: offset,
        limit: limit,
      );
      
      await _localDatasource.cacheNotes(updatedRemoteNotes);
      return updatedRemoteNotes;
    } catch (e) {
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
    try {
      final created = await _remoteDatasource.createNote(note);
      await _localDatasource.cacheNote(created);
      return created;
    } catch (_) {
      // Çevrimdışı kayıt (Offline Save)
      await _localDatasource.cacheNote(note);
      return note;
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final updated = await _remoteDatasource.updateNote(note);
      await _localDatasource.cacheNote(updated);
      return updated;
    } catch (_) {
      // Çevrimdışı kayıt (Offline Save)
      await _localDatasource.cacheNote(note);
      return note;
    }
  }

  @override
  Future<void> softDeleteNote(String noteId) async {
    try {
      await _remoteDatasource.softDeleteNote(noteId);
    } catch (_) {} // Ağ yoksa yoksay
    await _localDatasource.deleteCachedNote(noteId);
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    try {
      await _remoteDatasource.permanentlyDeleteNote(noteId);
    } catch (_) {} // Ağ yoksa yoksay
    await _localDatasource.deleteCachedNote(noteId);
  }

  @override
  Future<void> toggleFavorite(String noteId, bool isFavorite) async {
    try {
      await _remoteDatasource.toggleFavorite(noteId, isFavorite);
    } catch (_) {}
  }

  @override
  Future<void> togglePin(String noteId, bool isPinned) async {
    try {
      await _remoteDatasource.togglePin(noteId, isPinned);
    } catch (_) {}
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
    try {
      return await _remoteDatasource.getPublicNotes(offset: offset, limit: limit);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<NoteModel>> getSharedNotes({
    required String userId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      return await _remoteDatasource.getSharedNotes(
        userId: userId,
        offset: offset,
        limit: limit,
      );
    } catch (_) {
      return [];
    }
  }
}
