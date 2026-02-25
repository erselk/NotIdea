import 'package:flutter/material.dart';

class MarkdownSyntaxController extends TextEditingController {
  MarkdownSyntaxController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final markdownSyntaxColor =
        isDark ? Colors.blueGrey.shade400 : Colors.blueGrey.shade300;
    
    final baseStyle = style ?? const TextStyle();
    
    // Fallback if parsing fails or for empty text
    if (text.isEmpty) return TextSpan(style: baseStyle, text: text);

    return _parseMarkdown(text, baseStyle, markdownSyntaxColor);
  }

  TextSpan _parseMarkdown(String source, TextStyle baseStyle, Color syntaxColor) {
    final List<InlineSpan> spans = [];
    int currentPosition = 0;

    // A simple regex to catch bold, italic, headings, lists, underline
    final regExp = RegExp(
      r'(\*\*.*?\*\*|\*.*?\*|##+ .*|^- \[ \].*|^- \[x\].*|<u>.*?</u>|^> .*|^-\s.*)',
      multiLine: true,
      dotAll: false,
    );

    for (final match in regExp.allMatches(source)) {
      if (match.start > currentPosition) {
        spans.add(TextSpan(
          text: source.substring(currentPosition, match.start),
          style: baseStyle,
        ));
      }

      final matchedText = match.group(0)!;
      TextStyle currentStyle = baseStyle;
      List<InlineSpan> innerSpans = [];
      
      if (matchedText.startsWith('**') && matchedText.endsWith('**') && matchedText.length > 4) {
        currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
        innerSpans = [
          TextSpan(text: '**', style: baseStyle.copyWith(color: syntaxColor, fontSize: baseStyle.fontSize! * 0.9)),
          TextSpan(text: matchedText.substring(2, matchedText.length - 2), style: currentStyle),
          TextSpan(text: '**', style: baseStyle.copyWith(color: syntaxColor, fontSize: baseStyle.fontSize! * 0.9)),
        ];
      } else if (matchedText.startsWith('*') && matchedText.endsWith('*') && matchedText.length > 2) {
        currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
        innerSpans = [
          TextSpan(text: '*', style: baseStyle.copyWith(color: syntaxColor, fontSize: baseStyle.fontSize! * 0.9)),
          TextSpan(text: matchedText.substring(1, matchedText.length - 1), style: currentStyle),
          TextSpan(text: '*', style: baseStyle.copyWith(color: syntaxColor, fontSize: baseStyle.fontSize! * 0.9)),
        ];
      } else if (matchedText.startsWith('##')) {
        currentStyle = currentStyle.copyWith(
          fontSize: (baseStyle.fontSize ?? 14) * 1.5,
          fontWeight: FontWeight.bold,
          height: 1.8,
        );
        int spaceIndex = matchedText.indexOf(' ');
        if (spaceIndex > 0) {
          innerSpans = [
            TextSpan(text: matchedText.substring(0, spaceIndex + 1), style: currentStyle.copyWith(color: syntaxColor, fontWeight: FontWeight.normal)),
            TextSpan(text: matchedText.substring(spaceIndex + 1), style: currentStyle),
          ];
        } else {
             innerSpans = [TextSpan(text: matchedText, style: currentStyle)];
        }
      } else if (matchedText.startsWith('- [ ]')) {
        currentStyle = currentStyle.copyWith(color: syntaxColor.withOpacity(0.8));
        innerSpans = [
           TextSpan(text: '- [ ] ', style: currentStyle.copyWith(fontWeight: FontWeight.bold, fontSize: (baseStyle.fontSize ?? 14) * 1.2)),
           TextSpan(text: matchedText.substring(6), style: baseStyle),
        ];
      } else if (matchedText.startsWith('- [x]')) {
        currentStyle = currentStyle.copyWith(decoration: TextDecoration.lineThrough, color: syntaxColor);
        innerSpans = [
           TextSpan(text: '- [x] ', style: baseStyle.copyWith(color: Colors.green, fontWeight: FontWeight.bold, fontSize: (baseStyle.fontSize ?? 14) * 1.2, decoration: TextDecoration.none)),
           TextSpan(text: matchedText.substring(6), style: currentStyle),
        ];
      } else if (matchedText.startsWith('<u>') && matchedText.endsWith('</u>')) {
        currentStyle = currentStyle.copyWith(decoration: TextDecoration.underline);
        innerSpans = [
          TextSpan(text: '<u>', style: baseStyle.copyWith(color: syntaxColor, fontSize: baseStyle.fontSize! * 0.9)),
          TextSpan(text: matchedText.substring(3, matchedText.length - 4), style: currentStyle),
          TextSpan(text: '</u>', style: baseStyle.copyWith(color: syntaxColor, fontSize: baseStyle.fontSize! * 0.9)),
        ];
      } else {
        innerSpans = [TextSpan(text: matchedText, style: currentStyle)];
      }

      spans.addAll(innerSpans);
      currentPosition = match.end;
    }

    if (currentPosition < source.length) {
      spans.add(TextSpan(
        text: source.substring(currentPosition),
        style: baseStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}
