import 'package:flutter/material.dart';
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
    final hex = widget.note.color?.replaceFirst('#', '');
    if (hex == null || hex.isEmpty) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  IconData _visibilityIcon() {
    return switch (widget.note.visibility) {
      NoteVisibility.private_ => Icons.lock_outline,
      NoteVisibility.public_ => Icons.public,
      NoteVisibility.friends => Icons.people_outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = _parseNoteColor(context);
    final brightness = ThemeData.estimateBrightnessForColor(cardColor);
    final onCardColor =
        brightness == Brightness.dark ? Colors.white : Colors.black87;

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
            children: [
              // Title row with indicators
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.note.title.isEmpty ? 'Untitled' : widget.note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onCardColor,
                      ),
                    ),
                  ),
                  if (widget.note.isFavorite)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.favorite,
                        size: 16,
                        color: onCardColor.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Content preview
              if (widget.note.content.isNotEmpty)
                Expanded(
                  child: ClipRect(
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
                ),

              const SizedBox(height: 8),

              // Footer: date + visibility
              Row(
                children: [
                  Icon(
                    _visibilityIcon(),
                    size: 14,
                    color: onCardColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      timeago.format(widget.note.updatedAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: onCardColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  if (widget.note.tags.isNotEmpty)
                    Icon(
                      Icons.label_outline,
                      size: 14,
                      color: onCardColor.withValues(alpha: 0.5),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
