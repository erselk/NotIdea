import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/domain/repositories/notes_repository.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/notes/presentation/widgets/note_card.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        ref.read(noteFilterNotifierProvider.notifier).setSearchQuery(null);
      }
    });
  }

  void _showSortFilterSheet() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final filter = ref.read(noteFilterNotifierProvider);
    final notifier = ref.read(noteFilterNotifierProvider.notifier);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(l10n.sortBy, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.dateModified),
                  selected: filter.sortBy == NoteSortBy.updatedAt,
                  onSelected: (_) {
                    notifier.setSortBy(NoteSortBy.updatedAt);
                    Navigator.pop(ctx);
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.dateCreated),
                  selected: filter.sortBy == NoteSortBy.createdAt,
                  onSelected: (_) {
                    notifier.setSortBy(NoteSortBy.createdAt);
                    Navigator.pop(ctx);
                  },
                ),
                ChoiceChip(
                  label: Text(l10n.titleLabel),
                  selected: filter.sortBy == NoteSortBy.title,
                  onSelected: (_) {
                    notifier.setSortBy(NoteSortBy.title);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(l10n.filterBy, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.favorites),
                  selected: filter.isFavorite == true,
                  onSelected: (selected) {
                    notifier.setFavoriteFilter(selected ? true : null);
                    Navigator.pop(ctx);
                  },
                ),
                FilterChip(
                  label: Text(l10n.privateNotes),
                  selected: filter.visibility == NoteVisibility.private_,
                  onSelected: (selected) {
                    notifier.setVisibilityFilter(
                        selected ? NoteVisibility.private_ : null);
                    Navigator.pop(ctx);
                  },
                ),
                FilterChip(
                  label: Text(l10n.publicNotes),
                  selected: filter.visibility == NoteVisibility.public_,
                  onSelected: (selected) {
                    notifier.setVisibilityFilter(
                        selected ? NoteVisibility.public_ : null);
                    Navigator.pop(ctx);
                  },
                ),
                FilterChip(
                  label: Text(l10n.friendsNotes),
                  selected: filter.visibility == NoteVisibility.friends,
                  onSelected: (selected) {
                    notifier.setVisibilityFilter(
                        selected ? NoteVisibility.friends : null);
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  notifier.reset();
                  Navigator.pop(ctx);
                },
                child: Text(l10n.clearFilters),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteActions(dynamic note) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.edit),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/notes/edit/${note.id}');
                },
              ),
              ListTile(
                leading: Icon(
                  note.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                title: Text(
                  note.isFavorite
                      ? l10n.removeFromFavorites
                      : l10n.addToFavorites,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(toggleFavoriteProvider.notifier).execute(
                        note.id,
                        !note.isFavorite,
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text(l10n.share),
                onTap: () {
                  Navigator.pop(ctx);
                  // TODO: Paylaşım ekranı
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  l10n.delete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(note.id, note.title);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String noteId, String title) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.deleteNoteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(deleteNoteProvider.notifier).execute(noteId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final notesAsync = ref.watch(userNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchNotes,
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  ref.read(noteFilterNotifierProvider.notifier)
                      .setSearchQuery(query);
                },
              )
            : Text(l10n.myNotes),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortFilterSheet,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userNotesProvider);
        },
        child: notesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.errorLoadingNotes,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ref.invalidate(userNotesProvider),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
          data: (notes) {
            if (notes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.note_add_outlined,
                        size: 72,
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noNotesYet,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.createFirstNote,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NoteCard(
                  note: note,
                  onTap: () => context.push('/notes/${note.id}'),
                  onLongPress: () => _showNoteActions(note),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/notes/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
