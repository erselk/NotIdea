import 'package:markdown/markdown.dart' as md;

/// Markdown ++ ++ söz dizimine göre altı çizili metin için özel söz dizimi.
/// Hem note_card.dart hem de note_editor_screen.dart tarafından kullanılır.
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
