import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notidea/l10n/app_localizations.dart';

class MarkdownEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final Future<String?> Function(XFile file)? onImagePicked;

  const MarkdownEditor({
    super.key,
    required this.controller,
    this.readOnly = false,
    this.onChanged,
    this.onImagePicked,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  bool _isPreview = false;

  void _insertMarkdown(String before, [String after = '']) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final selectedText = selection.isValid
        ? text.substring(selection.start, selection.end)
        : '';

    final newText = '$before$selectedText$after';
    final cursorOffset = before.length + selectedText.length;

    if (selection.isValid) {
      widget.controller.text = text.replaceRange(
        selection.start,
        selection.end,
        newText,
      );
      widget.controller.selection = TextSelection.collapsed(
        offset: selection.start + cursorOffset,
      );
    } else {
      final offset = widget.controller.selection.baseOffset >= 0
          ? widget.controller.selection.baseOffset
          : text.length;
      widget.controller.text =
          text.substring(0, offset) + newText + text.substring(offset);
      widget.controller.selection = TextSelection.collapsed(
        offset: offset + cursorOffset,
      );
    }

    widget.onChanged?.call(widget.controller.text);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 80,
    );
    if (file == null) return;

    if (widget.onImagePicked != null) {
      final url = await widget.onImagePicked!(file);
      if (url != null) {
        _insertMarkdown('![image]($url)');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Toolbar
        if (!widget.readOnly)
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  _ToolbarButton(
                    icon: Icons.format_bold,
                    tooltip: l10n.bold,
                    onPressed: () => _insertMarkdown('**', '**'),
                  ),
                  _ToolbarButton(
                    icon: Icons.format_italic,
                    tooltip: l10n.italic,
                    onPressed: () => _insertMarkdown('*', '*'),
                  ),
                  _ToolbarDivider(),
                  _ToolbarButton(
                    icon: Icons.title,
                    tooltip: l10n.heading,
                    onPressed: () => _insertMarkdown('## '),
                  ),
                  _ToolbarButton(
                    icon: Icons.format_list_bulleted,
                    tooltip: l10n.bulletList,
                    onPressed: () => _insertMarkdown('- '),
                  ),
                  _ToolbarButton(
                    icon: Icons.format_list_numbered,
                    tooltip: l10n.numberedList,
                    onPressed: () => _insertMarkdown('1. '),
                  ),
                  _ToolbarDivider(),
                  _ToolbarButton(
                    icon: Icons.link,
                    tooltip: l10n.link,
                    onPressed: () => _insertMarkdown('[', '](url)'),
                  ),
                  _ToolbarButton(
                    icon: Icons.image_outlined,
                    tooltip: l10n.image,
                    onPressed: _pickImage,
                  ),
                  _ToolbarButton(
                    icon: Icons.code,
                    tooltip: l10n.code,
                    onPressed: () => _insertMarkdown('`', '`'),
                  ),
                  _ToolbarButton(
                    icon: Icons.format_quote,
                    tooltip: l10n.quote,
                    onPressed: () => _insertMarkdown('> '),
                  ),
                  _ToolbarDivider(),
                  _ToolbarButton(
                    icon: _isPreview
                        ? Icons.edit_outlined
                        : Icons.preview_outlined,
                    tooltip: _isPreview ? l10n.edit : l10n.preview,
                    onPressed: () {
                      setState(() => _isPreview = !_isPreview);
                    },
                  ),
                ],
              ),
            ),
          ),

        // Editor / Preview
        Expanded(
          child: _isPreview
              ? Markdown(
                  data: widget.controller.text,
                  selectable: true,
                  padding: const EdgeInsets.all(16),
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: theme.textTheme.bodyLarge,
                    h1: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    h2: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    code: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                )
              : TextField(
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: widget.onChanged,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.startWriting,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        minimumSize: const Size(36, 36),
        padding: const EdgeInsets.all(6),
      ),
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
