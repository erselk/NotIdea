import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/theme/app_colors.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/helpers.dart';
import 'package:notidea/core/utils/extensions.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:notidea/config/supabase_config.dart';
import 'package:notidea/core/constants/storage_constants.dart';
import 'package:notidea/core/utils/underline_syntax.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notidea/features/notes/presentation/widgets/share_note_dialog.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;
  /// Liste vb. ekranlardan açılırken veri zaten elde ise hemen gösterilir (renk gecikmesi olmaz).
  final NoteModel? initialNote;

  const NoteEditorScreen({super.key, this.noteId, this.initialNote});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final _titleController = TextEditingController();
  late quill.QuillController _contentController;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  final _mdToDelta = MarkdownToDelta(
    markdownDocument: md.Document(
      encodeHtml: false,
      extensionSet: md.ExtensionSet.gitHubFlavored,
      inlineSyntaxes: [UnderlineSyntax()],
    ),
    customElementToInlineAttribute: {
      'u': (_) => [quill.Attribute.underline],
    },
  );

  final _deltaToMd = DeltaToMarkdown(
    customTextAttrsHandlers: {
      quill.Attribute.italic.key: CustomAttributeHandler(
        beforeContent: (attribute, node, output) {
          if (node.previous?.style.attributes.containsKey(attribute.key) !=
              true) {
            output.write('*');
          }
        },
        afterContent: (attribute, node, output) {
          if (node.next?.style.attributes.containsKey(attribute.key) != true) {
            output.write('*');
          }
        },
      ),
      quill.Attribute.underline.key: CustomAttributeHandler(
        beforeContent: (attribute, node, output) {
          if (node.previous?.style.attributes.containsKey(attribute.key) !=
              true) {
            output.write('++');
          }
        },
        afterContent: (attribute, node, output) {
          if (node.next?.style.attributes.containsKey(attribute.key) != true) {
            output.write('++');
          }
        },
      ),
    },
  );

  bool _showColorPalette = false;

  NoteVisibility _visibility = NoteVisibility.private_;
  String? _selectedColor = NoteCardColors.lightColorHexes.isNotEmpty ? NoteCardColors.lightColorHexes[0] : null;
  bool _isFavorite = false;
  bool _isPinned = false;
  bool _isDeleted = false;
  bool _hasUnsavedChanges = false;
  bool _isInitialized = false;
  Timer? _autoSaveTimer;

  String? _currentNoteId;

  String _initialTitle = '';
  String _initialContent = '';
  NoteVisibility _initialVisibility = NoteVisibility.private_;
  String? _initialColor = NoteCardColors.lightColorHexes.isNotEmpty ? NoteCardColors.lightColorHexes[0] : null;

  bool get _isEditing => _currentNoteId != null;

  @override
  void initState() {
    super.initState();
    _currentNoteId = widget.noteId;

    final initial = widget.initialNote;
    if (initial != null && initial.id == widget.noteId) {
      _selectedColor = initial.color;
      _initialColor = initial.color;
      _visibility = initial.visibility;
      _initialVisibility = initial.visibility;
      _isFavorite = initial.isFavorite;
      _isPinned = initial.isPinned;
      _isDeleted = initial.isDeleted;
      _titleController.text = initial.title;
      _initialTitle = initial.title;
      _initialContent = initial.content;
      try {
        final delta = _mdToDelta.convert(initial.content);
        _contentController = quill.QuillController(
          document: quill.Document.fromDelta(delta),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {
        _contentController = quill.QuillController.basic();
      }
      _isInitialized = true;
    } else {
      _contentController = quill.QuillController.basic();
    }
    _contentController.document.changes.listen((_) => _onContentChanged());
  }

  static const _colorOptions = NoteCardColors.lightColorHexes;

  Color _noteBackgroundColor(ThemeData theme) {
    if (_selectedColor == null) return theme.scaffoldBackgroundColor;

    int index = NoteCardColors.lightColorHexes.indexOf(_selectedColor!);
    if (index != -1) {
      final isDark = theme.brightness == Brightness.dark;
      return isDark
          ? NoteCardColors.darkColors[index]
          : NoteCardColors.lightColors[index];
    }

    return Color(
      int.parse('FF${_selectedColor!.replaceFirst('#', '')}', radix: 16),
    );
  }

  bool _isBackgroundDark(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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
    try {
      final l10n = AppLocalizations.of(context)!;
      final currentUser = await ref.read(currentUserProvider.future);
      if (currentUser == null) return;

      final tags = <String>[];

      final now = DateTime.now();

      if (_isEditing) {
        final existing = await ref.read(
          noteByIdProvider(_currentNoteId!).future,
        );
        if (existing == null) {
          return;
        }

        final markdownContent = _deltaToMd.convert(
          _contentController.document.toDelta(),
        );

        final updated = existing.copyWith(
          title: _titleController.text.trim(),
          content: markdownContent,
          visibility: _visibility,
          color: _selectedColor,
          isPinned: _isPinned,
          isFavorite: _isFavorite,
          isDeleted: _isDeleted,
          tags: tags,
          updatedAt: now,
        );

        await ref.read(updateNoteProvider.notifier).execute(updated);
      } else {
        final newId = const Uuid().v4();
        final markdownContent = _deltaToMd.convert(
          _contentController.document.toDelta(),
        );
        final note = NoteModel(
          id: newId,
          userId: currentUser.id,
          title: _titleController.text.trim(),
          content: markdownContent,
          visibility: _visibility,
          color: _selectedColor,
          isPinned: _isPinned,
          isFavorite: _isFavorite,
          isDeleted: _isDeleted,
          tags: tags,
          createdAt: now,
          updatedAt: now,
        );

        await ref.read(createNoteProvider.notifier).execute(note);
        setState(() {
          _currentNoteId = newId;
        });
      }

      setState(() => _hasUnsavedChanges = false);

      if (showSnackbar && mounted) {
        context.showSuccess(l10n.noteSaved);
      }
    } catch (e) {
      if (mounted) {
        context.showError(e);
      }
      rethrow;
    }
  }

  void _resetChanges() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetConfirmTitle),
        content: Text(l10n.resetConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _titleController.text = _initialTitle;
                final delta = _mdToDelta.convert(_initialContent);
                final newDoc = quill.Document.fromDelta(delta);
                _contentController.document = newDoc;
                newDoc.changes.listen((_) => _onContentChanged());
                _visibility = _initialVisibility;
                _selectedColor = _initialColor;
                _hasUnsavedChanges = false;
              });
            },
            child: Text(l10n.resetChanges),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete() async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (!_isEditing) {
      context.pop();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_isDeleted ? l10n.deletePermanently : l10n.deleteNote),
        content: Text(_isDeleted ? l10n.deleteNotePermanentConfirm : l10n.deleteNoteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text(_isDeleted ? l10n.deletePermanently : l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && _isEditing) {
      if (_isDeleted) {
        await ref
            .read(permanentlyDeleteProvider.notifier)
            .execute(_currentNoteId!);
        if (mounted) {
          context.showSuccess(l10n.notePermanentlyDeleted);
          context.pop();
        }
      } else {
        await ref.read(deleteNoteProvider.notifier).execute(_currentNoteId!);
        if (mounted) {
          context.showSuccess(l10n.movedToTrash);
          context.pop();
        }
      }
    }
  }

  Future<void> _handlePin() async {
    final l10n = AppLocalizations.of(context)!;
    final newPinned = !_isPinned;

    if (_isEditing) {
      await ref
          .read(togglePinProvider.notifier)
          .execute(_currentNoteId!, newPinned);
    }

    if (mounted) {
      setState(() => _isPinned = newPinned);
      _onContentChanged();
      context.showSuccess(newPinned ? l10n.notePinned : l10n.noteUnpinned);
    }
  }

  Future<void> _handleFavorite() async {
    final newFav = !_isFavorite;

    if (_isEditing) {
      await ref
          .read(toggleFavoriteProvider.notifier)
          .execute(_currentNoteId!, newFav);
    }

    if (mounted) {
      setState(() => _isFavorite = newFav);
      _onContentChanged();
    }
  }

  void _handleShare() async {
    if (!_isEditing) {
      await _save(showSnackbar: false);
    }
    if (_isEditing && _currentNoteId != null) {
      final note = await ref.read(noteByIdProvider(_currentNoteId!).future);
      if (note != null && mounted) {
        ShareNoteDialog.show(context, note);
      }
    }
  }

  // --- End of Share Modal ---
  void _showInfoDialog() {
    final l10n = AppLocalizations.of(context)!;
    final wordCount = _deltaToMd
        .convert(_contentController.document.toDelta())
        .trim()
        .split(RegExp(r'\s+'))
        .length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.noteInfo),
        content: Text(l10n.wordCount(wordCount)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.ok)),
        ],
      ),
    );
  }

  Widget _buildFloatingToolbar(BuildContext context, bool isDarkBg) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final isAppDark = theme.brightness == Brightness.dark;
    final bgColor = appColors.surfaceVariant;
    final iconColor = appColors.textSecondary;
    final activeColor = theme.colorScheme.primary;

    Future<void> _showFontFamilyPicker() async {
      final l10n = AppLocalizations.of(context)!;
      final String? selectedFont = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            l10n.fontFamilyTitle,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.fontDefault),
                  onTap: () => Navigator.pop(ctx, 'Clear'),
                ),
                ListTile(
                  title: Text(
                    l10n.fontSerif,
                    style: const TextStyle(fontFamily: 'serif'),
                  ),
                  onTap: () => Navigator.pop(ctx, 'serif'),
                ),
                ListTile(
                  title: Text(
                    l10n.fontMonospace,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  onTap: () => Navigator.pop(ctx, 'monospace'),
                ),
                ListTile(
                  title: Text(
                    l10n.fontCursive,
                    style: const TextStyle(fontFamily: 'cursive'),
                  ),
                  onTap: () => Navigator.pop(ctx, 'cursive'),
                ),
              ],
            ),
          ),
        ),
      );

      if (selectedFont != null) {
        if (selectedFont == 'Clear') {
          _contentController.formatSelection(
            quill.Attribute.clone(quill.Attribute.font, null),
          );
        } else {
          _contentController.formatSelection(
            quill.Attribute.clone(quill.Attribute.font, selectedFont),
          );
        }
      }
    }

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file == null) return;

      final index = _contentController.selection.baseOffset;
      final length = _contentController.selection.extentOffset - index;

      // Hızlı (Çevrimdışı) Görsel Ekleme
      final localPath = file.path;
      _contentController.replaceText(
        index,
        length,
        quill.BlockEmbed.image(localPath),
        null,
      );

      try {
        final currentUser = await ref.read(currentUserProvider.future);
        final userId = currentUser?.id ?? 'anonymous';
        final ext = localPath.split('.').last;
        final fileName =
            'user_$userId/${DateTime.now().millisecondsSinceEpoch}.$ext';

        final bytes = await file.readAsBytes();
        await SupabaseConfig.storage
            .from(StorageConstants.noteImagesBucket)
            .uploadBinary(fileName, bytes);

        final imageUrl = SupabaseConfig.storage
            .from(StorageConstants.noteImagesBucket)
            .getPublicUrl(fileName);

        // Supabase linkiyle editor içindeki yerel linki değiştir
        final doc = _contentController.document;
        int offset = 0;
        for (var op in doc.toDelta().toList()) {
          if (op.isInsert &&
              op.data is Map &&
              (op.data as Map)['image'] == localPath) {
            _contentController.replaceText(
              offset,
              1,
              quill.BlockEmbed.image(imageUrl),
              null,
            );
            break;
          }
          final val = op.value;
          offset += (val is String) ? val.length : 1;
        }
      } catch (e) {
        // Sessizce başarısız ol; görsel çevrimdışı lokalde kalır
      }
    }

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: isDarkBg ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _showColorPalette
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ..._colorOptions.map((color) {
                    final index = NoteCardColors.lightColorHexes.indexOf(color);
                    final displayColor = index != -1
                        ? (isAppDark
                            ? NoteCardColors.darkColors[index]
                            : NoteCardColors.lightColors[index])
                        : Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16));
                    final isSelected = _selectedColor == color;
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedColor = color);
                            _onContentChanged();
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: displayColor,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: theme.colorScheme.primary, width: 2.5)
                                  : Border.all(color: Colors.transparent, width: 2.5),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Change color',
                        icon: Icon(Icons.palette_outlined, size: 26, color: activeColor),
                        onPressed: () => setState(() => _showColorPalette = false),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Word count',
                        icon: Icon(Icons.info_outline, size: 26, color: iconColor),
                        onPressed: _showInfoDialog,
                      ),
                    ),
                  ),
                  _buildAnimatedToggleBtn(quill.Attribute.bold, Icons.format_bold, activeColor, iconColor, 'Bold'),
                  _buildAnimatedToggleBtn(quill.Attribute.italic, Icons.format_italic, activeColor, iconColor, 'Italic'),
                  _buildAnimatedToggleBtn(quill.Attribute.underline, Icons.format_underline, activeColor, iconColor, 'Underline'),
                  _buildAnimatedToggleBtn(quill.Attribute.strikeThrough, Icons.format_strikethrough, activeColor, iconColor, 'Strikethrough'),
                  _buildAnimatedToggleBtn(quill.Attribute.inlineCode, Icons.code, activeColor, iconColor, 'Code'),
                  _buildAnimatedBlockBtn(quill.Attribute.ul, Icons.format_list_bulleted, activeColor, iconColor, 'Bullet list'),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Font',
                        icon: Icon(Icons.font_download_outlined, size: 26, color: iconColor),
                        onPressed: _showFontFamilyPicker,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Insert image',
                        icon: Icon(Icons.image_outlined, size: 26, color: iconColor),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Change color',
                        icon: Icon(Icons.palette_outlined, size: 26, color: iconColor),
                        onPressed: () => setState(() => _showColorPalette = true),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAnimatedToggleBtn(quill.Attribute attribute, IconData iconData, Color activeColor, Color iconColor, String tooltip) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, _) {
        final isSelected = _contentController.getSelectionStyle().containsKey(attribute.key);
        return SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: tooltip,
              icon: Icon(iconData, size: 26, color: isSelected ? activeColor : iconColor),
              onPressed: () {
                final isCurrentlySelected = _contentController.getSelectionStyle().containsKey(attribute.key);
                _contentController.formatSelection(isCurrentlySelected ? quill.Attribute.clone(attribute, null) : attribute);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBlockBtn(quill.Attribute attribute, IconData iconData, Color activeColor, Color iconColor, String tooltip) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, _) {
        final attr = _contentController.getSelectionStyle().attributes[attribute.key];
        final isSelected = attr?.value == attribute.value;
        return SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: tooltip,
              icon: Icon(iconData, size: 26, color: isSelected ? activeColor : iconColor),
              onPressed: () {
                final isCurrentlySelected = _contentController.getSelectionStyle().attributes[attribute.key]?.value == attribute.value;
                _contentController.formatSelection(isCurrentlySelected ? quill.Attribute.clone(attribute, null) : attribute);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_isEditing && !_isInitialized && widget.noteId != null) {
      final noteAsync = ref.watch(noteByIdProvider(widget.noteId!));
      noteAsync.whenData((note) {
        if (note != null && !_isInitialized) {
          _titleController.text = note.title;
          final delta = _mdToDelta.convert(note.content);
          final newDoc = quill.Document.fromDelta(delta);
          _contentController.document = newDoc;
          newDoc.changes.listen((_) => _onContentChanged());
          _visibility = note.visibility;
          _selectedColor = note.color;
          _isFavorite = note.isFavorite;
          _isPinned = note.isPinned;
          _isDeleted = note.isDeleted;

          _initialTitle = note.title;
          _initialContent = note.content;
          _initialVisibility = note.visibility;
          _initialColor = note.color;

          _isInitialized = true;
        }
      });
    } else if (!_isEditing && !_isInitialized) {
      _isInitialized = true;
    }

    final bgColor = _noteBackgroundColor(theme);
    final isDarkBg = _isBackgroundDark(bgColor);
    final appColors = theme.extension<AppColorsExtension>()!;
    final defaultTextColor = theme.brightness == Brightness.light
        ? appColors.textPrimary
        : theme.colorScheme.onSurface;
    final iconColor = isDarkBg ? getContrastTextColor(bgColor) : defaultTextColor;
    final textColorOnBg = isDarkBg ? getContrastTextColor(bgColor) : defaultTextColor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (_hasUnsavedChanges) {
          await _save(showSnackbar: false);
        }

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              scrolledUnderElevation: 0,
              iconTheme: IconThemeData(color: iconColor, size: 30),
              leadingWidth: 72,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () async {
                if (_hasUnsavedChanges) {
                  await _save(showSnackbar: false);
                }
                if (context.mounted) {
                  context.pop();
                }
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: iconColor,
              onPressed: _handleDelete,
              tooltip: _isDeleted ? l10n.deletePermanently : l10n.delete,
            ),
            IconButton(
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              color: _isPinned ? textColorOnBg : iconColor,
              onPressed: _handlePin,
              tooltip: _isPinned ? l10n.unpinNote : l10n.pinNote,
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              color: iconColor,
              onPressed: _handleShare,
              tooltip: l10n.share,
            ),
            IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_outline),
              color: _isFavorite ? textColorOnBg : iconColor,
              onPressed: _handleFavorite,
              tooltip: _isFavorite
                  ? l10n.removeFromFavorites
                  : l10n.addToFavorites,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.restart_alt),
                color: iconColor,
                onPressed: _hasUnsavedChanges ? _resetChanges : null,
                tooltip: l10n.resetChanges,
              ),
            ),
          ],
        ),
      ),
    ),
    body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(56, 8, 56, 0),
                    child: TextField(
                      controller: _titleController,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        height: 1.5,
                        letterSpacing: 20 * 0.005,
                        color: textColorOnBg,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.noteTitle,
                        hintStyle: TextStyle(
                          color: textColorOnBg.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        filled: false,
                        fillColor: Colors.transparent,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.only(bottom: 0),
                        counterText: '',
                      ),
                      maxLength: AppConstants.maxNoteTitleLength,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _onContentChanged(),
                    ),
                  ),
                  Divider(
                    height: 4,
                    thickness: 2.5,
                    color: textColorOnBg.withValues(alpha: 0.25),
                    indent: 56,
                    endIndent: 56,
                  ),
                  const SizedBox(height: 0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 56),
                      child: quill.QuillEditor(
                        focusNode: _focusNode,
                        scrollController: _scrollController,
                        controller: _contentController,
                        config: quill.QuillEditorConfig(
                          placeholder: l10n.startWriting,
                          padding: const EdgeInsets.only(bottom: 100, top: 4),
                          customStyles: quill.DefaultStyles(
                            placeHolder: quill.DefaultTextBlockStyle(
                              GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                height: 1.45,
                                letterSpacing: -0.25,
                                color: textColorOnBg.withValues(alpha: 0.5),
                              ),
                              const quill.HorizontalSpacing(0, 0),
                              const quill.VerticalSpacing(0, 0),
                              const quill.VerticalSpacing(0, 0),
                              null,
                            ),
                            paragraph: quill.DefaultTextBlockStyle(
                              GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                height: 1.45,
                                letterSpacing: -0.25,
                                color: textColorOnBg,
                              ),
                              const quill.HorizontalSpacing(0, 0),
                              const quill.VerticalSpacing(0, 0),
                              const quill.VerticalSpacing(0, 0),
                              null,
                            ),
                            h1: quill.DefaultTextBlockStyle(
                              GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                                height: 1.4,
                                letterSpacing: 20 * 0.005,
                                color: textColorOnBg,
                              ),
                              const quill.HorizontalSpacing(0, 0),
                              const quill.VerticalSpacing(16, 0),
                              const quill.VerticalSpacing(0, 0),
                              null,
                            ),
                          ),
                          embedBuilders: [
                            ...FlutterQuillEmbeds.editorBuilders(
                              imageEmbedConfig: QuillEditorImageEmbedConfig(
                                imageProviderBuilder: (context, imageUrl) {
                                  if (imageUrl.startsWith('http')) {
                                    return CachedNetworkImageProvider(imageUrl);
                                  }
                                  return FileImage(File(imageUrl));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: _buildFloatingToolbar(context, isDarkBg),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

