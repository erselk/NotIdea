import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'search_provider.g.dart';

@Riverpod(keepAlive: true)
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@riverpod
Future<List<NoteModel>> searchMyNotes(
  Ref ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  final currentUser = await ref.watch(currentUserProvider.future);
  if (currentUser == null) return [];

  final repository = ref.watch(notesRepositoryProvider);
  return repository.searchNotes(
    userId: currentUser.id,
    query: query.trim(),
  );
}

@riverpod
Future<List<NoteModel>> searchPublicNotesGlobal(
  Ref ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  final repository = ref.watch(notesRepositoryProvider);
  // Server-side ilike filtresi: veritabanında arama yap, tüm kayıtları çekme
  return repository.searchNotes(userId: '', query: query.trim(), limit: 50);
}

@riverpod
Future<List<ProfileModel>> searchUsersGlobal(
  Ref ref,
  String query,
) async {
  if (query.trim().length < 2) return [];

  return ref.watch(searchUsersProvider(query).future);
}
