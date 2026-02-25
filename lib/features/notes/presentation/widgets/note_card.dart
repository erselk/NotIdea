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

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
  });

  Color _parseNoteColor(BuildContext context) {
    if (note.color == null || note.color!.isEmpty) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
    try {
      final hex = note.color!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }

  IconData _visibilityIcon() {
    return switch (note.visibility) {
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

    // Parse pure text from Markdown via Quill Delta mechanism.
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
    
    String plainTextContent = note.content;
    try {
      final delta = customMdToDelta.convert(note.content);
      final rawStr = quill.Document.fromDelta(delta).toPlainText().trim();
      if (rawStr.isNotEmpty) {
        plainTextContent = rawStr;
      }
    } catch (_) {
      // Fallback
      plainTextContent = note.content;
    }

    final contentPreview = plainTextContent.length > 120
        ? '${plainTextContent.substring(0, 120)}…'
        : plainTextContent;

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
        onTap: onTap,
        onLongPress: onLongPress,
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
                      note.title.isEmpty ? 'Untitled' : note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onCardColor,
                      ),
                    ),
                  ),
                  if (note.isFavorite)
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
              if (contentPreview.isNotEmpty)
                Expanded(
                  child: Text(
                    contentPreview,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onCardColor.withValues(alpha: 0.75),
                      height: 1.4,
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
                      timeago.format(note.updatedAt),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: onCardColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  if (note.tags.isNotEmpty)
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
