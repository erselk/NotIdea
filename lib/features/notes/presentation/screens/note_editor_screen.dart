import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:notidea/l10n/app_localizations.dart';
import 'package:notidea/core/constants/app_constants.dart';
import 'package:notidea/core/theme/app_colors.dart';
import 'package:notidea/features/auth/presentation/providers/auth_provider.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:notidea/features/notes/presentation/providers/notes_provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
class NoteEditorScreen extends ConsumerStatefulWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class UnderlineSyntax extends md.DelimiterSyntax {
  UnderlineSyntax()
      : super(
          r'\+\+',
          requiresDelimiterRun: true,
          allowIntraWord: true,
          startCharacter: 43,
          tags: [md.DelimiterTag('u', 2)],
        );
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
          if (node.previous?.style.attributes.containsKey(attribute.key) != true) {
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
          if (node.previous?.style.attributes.containsKey(attribute.key) != true) {
            output.write('++');
          }
        },
        afterContent: (attribute, node, output) {
          if (node.next?.style.attributes.containsKey(attribute.key) != true) {
            output.write('++');
          }
        },
      ),
    }
  );

  bool _showColorPalette = false;
  bool _isPreview = false;

  NoteVisibility _visibility = NoteVisibility.private_;
  String? _selectedColor;
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
  String? _initialColor;

  bool get _isEditing => _currentNoteId != null;

  @override
  void initState() {
    super.initState();
    _currentNoteId = widget.noteId;
    _contentController = quill.QuillController.basic();
    _contentController.document.changes.listen((_) => _onContentChanged());
  }

  static const _colorOptions = [
    null, // null is for "white" or default background
    '#FCEEA7', // sari (yellow)
    '#D9ED92', // acik yesil (light green)
    '#79B669', // yesil (green)
    '#FFDCE0', // pembe (pink)
    '#CDB4DB', // acik mor (light purple)
    '#613F75', // mor (purple)
    '#A0C4FF', // acik mavi (light blue)
    '#1A759F', // mavi (blue)
  ];

  Color _noteBackgroundColor(ThemeData theme) {
    if (_selectedColor == null) return theme.scaffoldBackgroundColor;
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
        final existing =
            await ref.read(noteByIdProvider(_currentNoteId!).future);
        if (existing == null) {
          return;
        }

        final markdownContent = _deltaToMd.convert(_contentController.document.toDelta());
        debugPrint('--- SAVED MARKDOWN ---');
        debugPrint(markdownContent);
        debugPrint('----------------------');
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
        final markdownContent = _deltaToMd.convert(_contentController.document.toDelta());
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noteSaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> _saveAndPop() async {
    try {
      if (_hasUnsavedChanges) {
        await _save();
      }
      if (mounted) context.pop();
    } catch (e) {
      // Ignore pop if save failed, letting the user see the snackbar
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

    if (_isDeleted) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.deletePermanently),
          content: Text(l10n.deleteNotePermanentConfirm),
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
              child: Text(l10n.deletePermanently),
            ),
          ],
        ),
      );

      if (confirmed == true && _isEditing) {
        await ref
            .read(permanentlyDeleteProvider.notifier)
            .execute(_currentNoteId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notePermanentlyDeleted)),
          );
          context.pop();
        }
      }
    } else {
      if (_isEditing) {
        await ref.read(deleteNoteProvider.notifier).execute(_currentNoteId!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.movedToTrash)),
          );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newPinned ? l10n.notePinned : l10n.noteUnpinned),
        ),
      );
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

  void _handleShare() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
              leading: const Icon(Icons.send_outlined),
              title: Text(l10n.shareViaSocial),
              onTap: () {
                Navigator.pop(ctx);
                final title = _titleController.text.trim();
                final content = _deltaToMd.convert(_contentController.document.toDelta()).trim();
                final text = title.isNotEmpty
                    ? '$title\n\n$content'
                    : content;
                Share.share(text);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: Text(l10n.shareViaLink),
              subtitle: Text(l10n.selectPermission),
              onTap: () async {
                Navigator.pop(ctx);
                if (!_isEditing) {
                  await _save(showSnackbar: false);
                }
                if (_isEditing) {
                  _showPermissionSheet();
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showPermissionSheet() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                l10n.selectPermission,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: Text(l10n.readOnlyPermission),
              onTap: () {
                Navigator.pop(ctx);
                _createAndCopyShareLink('read_only');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note_outlined),
              title: Text(l10n.readWritePermission),
              onTap: () {
                Navigator.pop(ctx);
                _createAndCopyShareLink('read_write');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _createAndCopyShareLink(String permission) async {
    if (!_isEditing) return;
    final l10n = AppLocalizations.of(context)!;
    final currentUser = await ref.read(currentUserProvider.future);
    if (currentUser == null) return;

    try {
      final token = await ref.read(createShareLinkProvider.notifier).execute(
            noteId: _currentNoteId!,
            sharedByUserId: currentUser.id,
            permission: permission,
          );

      final link = 'https://notidea.app/shared/$token';
      await Clipboard.setData(ClipboardData(text: link));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.linkCopied)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
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
                            color: _isBackgroundDark(displayColor)
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


  void _showInfoDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Not Bilgisi'),
        content: Text('Kelime Sayısı: ${_deltaToMd.convert(_contentController.document.toDelta()).trim().split(RegExp(r'\s+')).length}'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.ok))],
      ),
    );
  }

  Widget _buildFloatingToolbar(BuildContext context, bool isDarkBg) {
    final theme = Theme.of(context);
    final isAppDark = theme.brightness == Brightness.dark;
    final bgColor = isAppDark ? Colors.grey[900] : Colors.black;
    final iconColor = Colors.white; 
    final activeColor = Colors.greenAccent; 

    Future<void> _showFontFamilyPicker() async {
      final String? selectedFont = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.noteTitle, style: TextStyle(color: isAppDark ? Colors.white : Colors.black)),
          backgroundColor: isAppDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Default (System)'),
                  onTap: () => Navigator.pop(ctx, 'Clear'),
                ),
                ListTile(
                  title: const Text('Serif', style: TextStyle(fontFamily: 'serif')),
                  onTap: () => Navigator.pop(ctx, 'serif'),
                ),
                ListTile(
                  title: const Text('Monospace', style: TextStyle(fontFamily: 'monospace')),
                  onTap: () => Navigator.pop(ctx, 'monospace'),
                ),
                ListTile(
                  title: const Text('Cursive', style: TextStyle(fontFamily: 'cursive')),
                  onTap: () => Navigator.pop(ctx, 'cursive'),
                ),
              ],
            ),
          ),
        ),
      );

      if (selectedFont != null) {
        if (selectedFont == 'Clear') {
          _contentController.formatSelection(quill.Attribute.clone(quill.Attribute.font, null));
        } else {
          _contentController.formatSelection(quill.Attribute.clone(quill.Attribute.font, selectedFont));
        }
      }
    }

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (file == null) return;
      
      final index = _contentController.selection.baseOffset;
      final length = _contentController.selection.extentOffset - index;
      _contentController.replaceText(index, length, quill.BlockEmbed.image(file.path), null);
    }

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkBg ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _showColorPalette 
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _colorOptions.map((color) {
                    final displayColor = color != null
                        ? Color(int.parse('FF${color.replaceFirst('#', '')}', radix: 16))
                        : (isAppDark ? Colors.grey[700]! : Colors.grey[300]!); 
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedColor = color);
                        _onContentChanged();
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: displayColor,
                          shape: BoxShape.circle,
                          border: isSelected 
                              ? Border.all(color: Colors.white, width: 2.5) 
                              : Border.all(color: Colors.transparent, width: 2.5),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.info_outline, size: 22), color: iconColor, onPressed: _showInfoDialog, visualDensity: VisualDensity.compact),
                      quill.QuillSimpleToolbar(
                        controller: _contentController,
                        config: quill.QuillSimpleToolbarConfig(
                          color: Colors.transparent,
                          buttonOptions: quill.QuillSimpleToolbarButtonOptions(
                            base: quill.QuillToolbarBaseButtonOptions(
                              iconTheme: quill.QuillIconTheme(
                                iconButtonSelectedData: quill.IconButtonData(color: activeColor),
                                iconButtonUnselectedData: quill.IconButtonData(color: iconColor),
                              ),
                            ),
                          ),
                          showListCheck: true,
                          showBoldButton: true,
                          showItalicButton: true,
                          showUnderLineButton: true,
                          showListBullets: false,
                          showListNumbers: false,
                          showUndo: false,
                          showRedo: false,
                          showSearchButton: false,
                          showSubscript: false,
                          showSuperscript: false,
                          showFontFamily: false,
                          showFontSize: false,
                          showHeaderStyle: false,
                          showStrikeThrough: false,
                          showInlineCode: false,
                          showColorButton: false,
                          showBackgroundColorButton: false,
                          showClearFormat: false,
                          showAlignmentButtons: false,
                          showLeftAlignment: false,
                          showCenterAlignment: false,
                          showRightAlignment: false,
                          showJustifyAlignment: false,
                          showDirection: false,
                          showCodeBlock: false,
                          showQuote: false,
                          showIndent: false,
                          showLink: false,
                          showClipboardCopy: false,
                          showClipboardCut: false,
                          showClipboardPaste: false,
                          showDividers: false,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.font_download_outlined, size: 22), 
                        color: iconColor, 
                        onPressed: _showFontFamilyPicker, 
                        visualDensity: VisualDensity.compact
                      ),
                      IconButton(
                        icon: const Icon(Icons.image_outlined, size: 22), 
                        color: iconColor, 
                        onPressed: _pickImage, 
                        visualDensity: VisualDensity.compact
                      ),
                    ],
                  ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 4.0),
            child: IconButton(
              icon: Icon(_showColorPalette ? Icons.palette : Icons.palette_outlined),
              color: _showColorPalette ? activeColor : iconColor,
              onPressed: () => setState(() => _showColorPalette = !_showColorPalette),
            ),
          ),
        ],
      ),
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
    final iconColor = isDarkBg ? AppColors.white : theme.colorScheme.onSurface;
    final textColorOnBg =
        isDarkBg ? AppColors.white : theme.colorScheme.onSurface;

    final visibilityIcon = switch (_visibility) {
      NoteVisibility.private_ => Icons.lock_outline,
      NoteVisibility.public_ => Icons.public,
      NoteVisibility.friends => Icons.people_outline,
    };

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: iconColor),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (_hasUnsavedChanges) {
                await _save(showSnackbar: false);
              }
              if (context.mounted) {
                context.pop();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: iconColor,
              onPressed: _handleDelete,
              tooltip: _isDeleted ? l10n.deletePermanently : l10n.delete,
            ),
            IconButton(
              icon: Icon(
                _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              color: _isPinned ? theme.colorScheme.primary : iconColor,
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
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_outline,
              ),
              color: _isFavorite ? theme.colorScheme.error : iconColor,
              onPressed: _handleFavorite,
              tooltip: _isFavorite
                  ? l10n.removeFromFavorites
                  : l10n.addToFavorites,
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              color: iconColor,
              onPressed: _hasUnsavedChanges ? _resetChanges : null,
              tooltip: l10n.resetChanges,
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
                    child: TextField(
                      controller: _titleController,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
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
                        contentPadding: const EdgeInsets.only(bottom: 16),
                        counterText: '',
                      ),
                      maxLength: AppConstants.maxNoteTitleLength,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => _onContentChanged(),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1.2,
                    color: textColorOnBg.withValues(alpha: 0.15),
                    indent: 28,
                    endIndent: 28,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: quill.QuillEditor(
                        focusNode: _focusNode,
                        scrollController: _scrollController,
                        controller: _contentController,
                        config: quill.QuillEditorConfig(
                          placeholder: l10n.startWriting,
                          padding: const EdgeInsets.only(bottom: 100, top: 8),
                          customStyles: quill.DefaultStyles(
                            paragraph: quill.DefaultTextBlockStyle(
                              theme.textTheme.bodyLarge!.copyWith(
                                color: textColorOnBg,
                                height: 1.6,
                              ),
                              const quill.HorizontalSpacing(0, 0),
                              const quill.VerticalSpacing(0, 0),
                              const quill.VerticalSpacing(0, 0),
                              null,
                            ),
                            h1: quill.DefaultTextBlockStyle(
                              theme.textTheme.headlineMedium!.copyWith(
                                color: textColorOnBg,
                                fontWeight: FontWeight.bold,
                              ),
                              const quill.HorizontalSpacing(0, 0),
                              const quill.VerticalSpacing(16, 0),
                              const quill.VerticalSpacing(0, 0),
                              null,
                            ),
                          ),
                          embedBuilders: [
                            ...FlutterQuillEmbeds.editorBuilders(
                              imageEmbedConfig: const QuillEditorImageEmbedConfig(),
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
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFloatingToolbar(context, isDarkBg),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
