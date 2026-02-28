import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// NotIdea yazı logosu.
/// Dark modda sadece siyah (#374241) kısım açık renge döner, yeşil (#06A74D) sabit kalır.
class NotIdeaLogoText extends StatelessWidget {
  const NotIdeaLogoText({super.key, this.width, this.height});

  final double? width;
  final double? height;

  static const _asset = 'assets/images/notidea.svg';
  static const _blackFill = 'fill="#374241"';
  static const _whiteFillDark = 'fill="#E5EAE4"';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder<String>(
      future: rootBundle.loadString(_asset),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(width: width, height: height);
        }
        String svg = snapshot.data!;
        if (isDark) svg = svg.replaceAll(_blackFill, _whiteFillDark);
        return SvgPicture.string(svg, width: width, height: height);
      },
    );
  }
}
