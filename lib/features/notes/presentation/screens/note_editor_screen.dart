import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/theme/app_colors.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/features/notes/presentation/widgets/markdown_editor.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  NoteVisibility _visibility = NoteVisibility.private_;
  String? _selectedColor;
  bool _hasUnsavedChanges = false;
  bool _isInitialized = false;
  Timer? _autoSaveTimer;

  bool get _isEditing => widget.noteId != null;

  static const _colorOptions = [
    null,
    '#DAEDD5',
    '#1A759F',
    '#613F75',
    '#CDB4DB',
    '#FFDCE0',
    '#79B669',
    '#D9ED92',
    '#F7EF81',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 30), _autoSave);
  }

  Future<void> _autoSave() async {
    if (!_hasUnsavedChanges) return;
    await _save(showSnackbar: false);
  }

  Future<void> _save({bool showSnackbar = true}) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = await ref.read(currentUserProvider.future);
    if (currentUser == null) return;

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final now = DateTime.now();

    if (_isEditing) {
      final existing =
          await ref.read(noteByIdProvider(widget.noteId!).future);
      if (existing == null) return;

      final updated = existing.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text,
        visibility: _visibility,
        color: _selectedColor,
        tags: tags,
        updatedAt: now,
      );

      await ref.read(updateNoteProvider.notifier).execute(updated);
    } else {
      final note = NoteModel(
        id: const Uuid().v4(),
        userId: currentUser.id,
        title: _titleController.text.trim(),
        content: _contentController.text,
        visibility: _visibility,
        color: _selectedColor,
        tags: tags,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(createNoteProvider.notifier).execute(note);
    }

    setState(() => _hasUnsavedChanges = false);

    if (showSnackbar && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noteSaved)),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.unsavedChanges),
        content: Text(l10n.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.discard),
          ),
          FilledButton(
            onPressed: () async {
              await _save();
              if (ctx.mounted) Navigator.pop(ctx, true);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showColorPicker() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
            Text(l10n.noteColor, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colorOptions.map((color) {
                final isSelected = color == _selectedColor;
                final displayColor = color != null
                    ? Color(int.parse('FF${color.replaceFirst('#', '')}',
                        radix: 16))
                    : theme.colorScheme.surfaceContainerHighest;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = color);
                    _onContentChanged();
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: displayColor,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 3,
                            )
                          : Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: ThemeData.estimateBrightnessForColor(
                                        displayColor) ==
                                    Brightness.dark
                                ? AppColors.white
                                : AppColors.black,
                            size: 20,
                          )
                        : color == null
                            ? Icon(
                                Icons.format_color_reset,
                                size: 20,
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                            : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showVisibilityPicker() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(l10n.privateNotes),
              subtitle: Text(l10n.onlyYouCanSee),
              selected: _visibility == NoteVisibility.private_,
              selectedTileColor:
                  theme.colorScheme.primary.withValues(alpha: 0.08),
              onTap: () {
                setState(() => _visibility = NoteVisibility.private_);
                _onContentChanged();
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(l10n.friendsNotes),
              subtitle: Text(l10n.friendsCanSee),
              selected: _visibility == NoteVisibility.friends,
              selectedTileColor:
                  theme.colorScheme.primary.withValues(alpha: 0.08),
              onTap: () {
                setState(() => _visibility = NoteVisibility.friends);
                _onContentChanged();
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: Text(l10n.publicNotes),
              subtitle: Text(l10n.everyoneCanSee),
              selected: _visibility == NoteVisibility.public_,
              selectedTileColor:
                  theme.colorScheme.primary.withValues(alpha: 0.08),
              onTap: () {
                setState(() => _visibility = NoteVisibility.public_);
                _onContentChanged();
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Load existing note data
    if (_isEditing && !_isInitialized) {
      final noteAsync = ref.watch(noteByIdProvider(widget.noteId!));
      noteAsync.whenData((note) {
        if (note != null && !_isInitialized) {
          _titleController.text = note.title;
          _contentController.text = note.content;
          _visibility = note.visibility;
          _selectedColor = note.color;
          _tagsController.text = note.tags.join(', ');
          _isInitialized = true;
        }
      });
    } else if (!_isEditing) {
      _isInitialized = true;
    }

    final createState = ref.watch(createNoteProvider);
    final updateState = ref.watch(updateNoteProvider);
    final isSaving = createState.isLoading || updateState.isLoading;

    final visibilityIcon = switch (_visibility) {
      NoteVisibility.private_ => Icons.lock_outline,
      NoteVisibility.public_ => Icons.public,
      NoteVisibility.friends => Icons.people_outline,
    };

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? l10n.editNote : l10n.newNote),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (_hasUnsavedChanges) {
                final shouldPop = await _onWillPop();
                if (shouldPop && mounted) context.pop();
              } else {
                context.pop();
              }
            },
          ),
          actions: [
            // Color picker
            IconButton(
              icon: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedColor != null
                      ? Color(int.parse(
                          'FF${_selectedColor!.replaceFirst('#', '')}',
                          radix: 16))
                      : theme.colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
              onPressed: _showColorPicker,
              tooltip: l10n.noteColor,
            ),
            // Visibility
            IconButton(
              icon: Icon(visibilityIcon),
              onPressed: _showVisibilityPicker,
              tooltip: l10n.visibility,
            ),
            // Save
            IconButton(
              icon: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.check,
                      color: _hasUnsavedChanges
                          ? theme.colorScheme.primary
                          : null,
                    ),
              onPressed: isSaving ? null : _save,
              tooltip: l10n.save,
            ),
          ],
        ),
        body: Column(
          children: [
            // Auto-save indicator
            if (_hasUnsavedChanges)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: Text(
                  l10n.unsavedChanges,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _titleController,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: l10n.noteTitle,
                  border: InputBorder.none,
                  counterText: '',
                ),
                maxLength: AppConstants.maxNoteTitleLength,
                maxLines: 1,
                onChanged: (_) => _onContentChanged(),
              ),
            ),

            // Tags
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _tagsController,
                style: theme.textTheme.bodySmall,
                decoration: InputDecoration(
                  hintText: l10n.tagsHint,
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.label_outline,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 28, minHeight: 0),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (_) => _onContentChanged(),
              ),
            ),

            Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),

            // Markdown editor
            Expanded(
              child: MarkdownEditor(
                controller: _contentController,
                onChanged: (_) => _onContentChanged(),
                onImagePicked: (file) async {
                  // TODO: Resmi Supabase Storage'a yükle ve URL döndür
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
