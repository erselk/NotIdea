import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/friends/presentation/providers/friends_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/profile/domain/models/profile_model.dart';

part 'search_provider.g.dart';

@riverpod
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
  SearchMyNotesRef ref,
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
  SearchPublicNotesGlobalRef ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  final repository = ref.watch(notesRepositoryProvider);
  final allPublic = await repository.getPublicNotes(limit: 100);
  final lowerQuery = query.toLowerCase();

  return allPublic
      .where(
        (note) =>
            note.title.toLowerCase().contains(lowerQuery) ||
            note.content.toLowerCase().contains(lowerQuery),
      )
      .toList();
}

@riverpod
Future<List<ProfileModel>> searchUsersGlobal(
  SearchUsersGlobalRef ref,
  String query,
) async {
  if (query.trim().length < 2) return [];

  return ref.watch(searchUsersProvider(query).future);
}
