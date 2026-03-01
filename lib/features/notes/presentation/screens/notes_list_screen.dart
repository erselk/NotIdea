import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/notes/presentation/widgets/note_card.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:notidea/shared/widgets/notidea_logo_text.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/features/notes/presentation/widgets/share_note_dialog.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic>? _cachedNotes;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _debounce?.cancel();
        ref.read(noteFilterProvider.notifier).setSearchQuery(null);
      }
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      ref.read(noteFilterProvider.notifier).setSearchQuery(query.trim().isEmpty ? null : query);
    });
  }


  void _showNoteActions(NoteModel note) {
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
                  context.push('/home/editor/${note.id}', extra: note);
                },
              ),
              ListTile(
                leading: Icon(
                  note.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                ),
                title: Text(
                  note.isPinned ? l10n.unpinNote : l10n.pinNote,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(togglePinProvider.notifier).execute(
                        note.id,
                        !note.isPinned,
                      );
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
                  ShareNoteDialog.show(context, note);
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

  Widget _buildNotesList(BuildContext context, List<dynamic> notes, ThemeData theme, dynamic l10n) {
    final pinnedNotes = notes.where((n) => n.isPinned).toList();
    final unpinnedNotes = notes.where((n) => !n.isPinned).toList();
    final sortedNotes = [...pinnedNotes, ...unpinnedNotes];

    return MasonryGridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemCount: sortedNotes.length,
      itemBuilder: (context, index) {
        final note = sortedNotes[index];
        return NoteCard(
          note: note,
          onTap: () => context.push('/home/editor/${note.id}', extra: note),
          onLongPress: () => _showNoteActions(note),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final notesAsync = ref.watch(userNotesProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: AnimatedContainer(
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          color: _isSearching
              ? Colors.transparent
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        ),
        leadingWidth: 72,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: const Icon(Icons.menu, size: 28),
                tooltip: 'Open menu',
                onPressed: () => AppScaffold.openDrawer(context),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              height: 36,
            ),
            const SizedBox(width: 10),
            const NotIdeaLogoText(height: 28),
          ],
        ),
        actionsIconTheme: IconThemeData(size: 28),
        actions: [
          SizedBox(
            width: 72,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    icon: Icon(Icons.search, size: 28,
                      color: _isSearching ? theme.colorScheme.primary : null,
                    ),
                    tooltip: 'Search notes',
                    onPressed: _toggleSearch,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: _isSearching
                ? AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    opacity: _isSearching ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: appColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: appColors.textPrimary,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search in the Notes',
                            hintStyle: TextStyle(color: appColors.textTertiary),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 36,
                              right: 20,
                              top: 14,
                              bottom: 14,
                            ),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(userNotesProvider);
              },
              child: notesAsync.when(
                loading: () {
                  // Önceki veriler varsa loading ekranı gösterme
                  if (_cachedNotes != null && _cachedNotes!.isNotEmpty) {
                    return _buildNotesList(context, _cachedNotes!, theme, l10n);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
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
                  // Notları hafızada tut
                  _cachedNotes = notes;

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

                  return _buildNotesList(context, notes, theme, l10n);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () => context.push('/home/editor'),
          tooltip: 'New note',
          elevation: 3,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

