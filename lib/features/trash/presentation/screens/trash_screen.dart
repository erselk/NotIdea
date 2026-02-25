import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/features/trash/presentation/providers/trash_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notidea/shared/widgets/app_scaffold.dart';
import 'package:notidea/shared/widgets/branded_app_bar.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final trashAsync = ref.watch(trashedNotesProvider);

    ref.listen(restoreNoteProvider, (prev, next) {
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noteRestored)),
        );
      }
    });

    ref.listen(emptyTrashProvider, (prev, next) {
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.successDeleted)),
        );
      }
    });

    return Scaffold(
      appBar: BrandedAppBar(
        titleFirst: 'Tr',
        titleSecond: 'ash',
        actions: [
          trashAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (notes) {
              if (notes.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: l10n.emptyTrash,
                onPressed: () => _confirmEmptyTrash(context, ref, l10n, theme),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(trashedNotesProvider),
        child: trashAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48,
                      color: theme.colorScheme.error),
                  const SizedBox(height: 16),
                  Text(error.toString()),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => ref.invalidate(trashedNotesProvider),
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
                        Icons.delete_outline,
                        size: 72,
                        color: appColors.primary.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.trashEmpty,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.trashEmptyDesc,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: appColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: appColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: appColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18,
                          color: appColors.warning),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.trashAutoDeleteInfo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: appColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MasonryGridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final deletedDate = note.deletedAt?.formattedDate ?? '';

                      return Card(
                        elevation: 0,
                        color: appColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: appColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            // Show bottom sheet with actions for trash
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.restore),
                                    title: Text(l10n.restoreNote),
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      ref
                                          .read(restoreNoteProvider.notifier)
                                          .execute(note.id);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
                                    title: Text(l10n.deletePermanently, style: TextStyle(color: theme.colorScheme.error)),
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      _confirmPermanentDelete(
                                        context,
                                        ref,
                                        l10n,
                                        theme,
                                        note.id,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.title.isEmpty ? 'Untitled' : note.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: appColors.textPrimary,
                                  ),
                                ),
                                if (note.content.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    note.content.length > 100
                                        ? '${note.content.substring(0, 100)}...'
                                        : note.content,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: appColors.textTertiary,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.auto_delete_outlined, size: 12,
                                        color: appColors.textTertiary),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        deletedDate,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: appColors.textTertiary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _confirmPermanentDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
    String noteId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deletePermanently),
        content: Text(l10n.deleteNotePermanentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(permanentlyDeleteProvider.notifier).execute(noteId);
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

  void _confirmEmptyTrash(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.emptyTrash),
        content: Text(l10n.emptyTrashConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(emptyTrashProvider.notifier).execute();
            },
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.emptyTrash),
          ),
        ],
      ),
    );
  }
}
