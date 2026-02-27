import 'package:flutter/material.dart';
import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/helpers.dart';
import 'package:notidea/features/notes/domain/models/note_model.dart';
import 'package:notidea/features/notes/domain/models/note_visibility.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:markdown/markdown.dart' as md;

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

class _ImagePlaceholderEmbedBuilder extends quill.EmbedBuilder {
  final ThemeData theme;
  final Color onCardColor;

  const _ImagePlaceholderEmbedBuilder({
    required this.theme,
    required this.onCardColor,
  });

  @override
  String get key => 'image';

  @override
  bool get expanded => false;

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: widget, alignment: PlaceholderAlignment.middle);
  }

  @override
  Widget build(BuildContext context, quill.EmbedContext embedContext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2, top: 2, right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: onCardColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined,
              size: 12, color: onCardColor.withValues(alpha: 0.8)),
          const SizedBox(width: 4),
          Text(
            'Görsel',
            style: theme.textTheme.bodySmall?.copyWith(
              color: onCardColor.withValues(alpha: 0.8),
              fontSize: 10,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatefulWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(NoteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.content != widget.note.content) {
      _initController();
    }
  }

  void _initController() {
    final customMdToDelta = MarkdownToDelta(
      markdownDocument: md.Document(
        encodeHtml: false,
        extensionSet: md.ExtensionSet.gitHubFlavored,
        inlineSyntaxes: [UnderlineSyntax()],
      ),
      customElementToInlineAttribute: {
        'u': (_) => [quill.Attribute.underline],
      },
    );
    try {
      final delta = customMdToDelta.convert(widget.note.content);
      _controller = quill.QuillController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    } catch (_) {
      // Fallback
      _controller = quill.QuillController(
        document: quill.Document(),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _parseNoteColor(BuildContext context) {
    return noteColorHexToThemeColor(context, widget.note.color);
  }

  // Visibility icon removed


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = _parseNoteColor(context);
    final brightness = ThemeData.estimateBrightnessForColor(cardColor);
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    final onCardColor = brightness == Brightness.dark
        ? appColors.textPrimaryDark
        : appColors.textPrimaryLight;

    return Card(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title row with indicators
              if (widget.note.title.isNotEmpty)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.note.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: onCardColor,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (widget.note.isFavorite)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.favorite,
                          size: 16,
                          color: onCardColor.withValues(alpha: 0.7),
                        ),
                      ),
                    if (widget.note.isPinned)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.push_pin,
                          size: 16,
                          color: onCardColor.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              
              if (widget.note.title.isNotEmpty && widget.note.content.isNotEmpty)
                const SizedBox(height: 10),

              // Content preview
              if (widget.note.content.isNotEmpty)
                ClipRect(
                  child: IgnorePointer(
                    child: quill.QuillEditor(
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                      controller: _controller,
                      config: quill.QuillEditorConfig(
                        checkBoxReadOnly: true,
                        scrollable: false,
                        expands: false,
                        padding: EdgeInsets.zero,
                        maxHeight: 200, // Limit content height so bento boxes don't get absurdly long
                        embedBuilders: [
                          _ImagePlaceholderEmbedBuilder(
                            theme: theme,
                            onCardColor: onCardColor,
                          ),
                        ],
                        customStyles: quill.DefaultStyles(
                          paragraph: quill.DefaultTextBlockStyle(
                            theme.textTheme.bodySmall!.copyWith(
                              color: onCardColor.withValues(alpha: 0.75),
                              height: 1.4,
                            ),
                            const quill.HorizontalSpacing(0, 0),
                            const quill.VerticalSpacing(0, 0),
                            const quill.VerticalSpacing(0, 0),
                            null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              if (widget.note.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.label_outline,
                      size: 14,
                      color: onCardColor.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
