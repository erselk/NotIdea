import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';

class NoteDetailScreen extends ConsumerWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final clean = hex.replaceFirst('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final noteAsync = ref.watch(noteByIdProvider(noteId));
    final currentUserAsync = ref.watch(currentUserProvider);

    return noteAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
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
                  l10n.errorLoadingNote,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => ref.invalidate(noteByIdProvider(noteId)),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (note) {
        if (note == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(l10n.noteNotFound),
            ),
          );
        }

        final noteColor = _parseColor(note.color);
        final bgColor = noteColor?.withValues(alpha: 0.15);
        final isOwner = currentUserAsync.valueOrNull?.id == note.userId;

        final visibilityIcon = switch (note.visibility) {
          NoteVisibility.private_ => Icons.lock_outline,
          NoteVisibility.public_ => Icons.public,
          NoteVisibility.friends => Icons.people_outline,
        };

        final visibilityLabel = switch (note.visibility) {
          NoteVisibility.private_ => l10n.privateNotes,
          NoteVisibility.public_ => l10n.publicNotes,
          NoteVisibility.friends => l10n.friendsNotes,
        };

        return Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            title: Text(
              note.title.isEmpty ? l10n.untitled : note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              // Favorite toggle
              IconButton(
                icon: Icon(
                  note.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: note.isFavorite ? theme.colorScheme.error : null,
                ),
                onPressed: () {
                  ref.read(toggleFavoriteProvider.notifier).execute(
                        note.id,
                        !note.isFavorite,
                      );
                },
              ),
              // Share
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  Share.share('${note.title}\n\n${note.content}');
                },
              ),
              if (isOwner) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push('/notes/edit/${note.id}'),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _confirmDelete(context, ref, note.id, l10n);
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.delete,
                            style:
                                TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          body: Container(
            color: bgColor,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta info
                  Row(
                    children: [
                      Icon(
                        visibilityIcon,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        visibilityLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeago.format(note.updatedAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  // Tags
                  if (note.tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: note.tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelStyle: theme.textTheme.labelSmall,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 16),
                  Divider(
                    color: theme.colorScheme.outlineVariant
                        .withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),

                  // Markdown content
                  MarkdownBody(
                    data: note.content,
                    selectable: true,
                    styleSheet:
                        MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                      h1: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      h2: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      h3: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      code: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                      blockquoteDecoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String noteId,
    AppLocalizations l10n,
  ) {
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
              context.pop();
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
}
