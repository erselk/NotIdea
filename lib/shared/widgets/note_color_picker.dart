import 'package:flutter/material.dart';

import 'package:notidea/core/theme/theme_extensions.dart';
import 'package:notidea/core/utils/helpers.dart';

/// The canonical names for note card colors, matching [NoteCardColors] order.
const noteColorNames = [
  'mint',
  'ocean',
  'purple',
  'lavender',
  'rose',
  'green',
  'lime',
  'yellow',
];

/// Horizontal color picker for note cards.
///
/// Returns the selected color name (e.g. `'mint'`, `'ocean'`) via [onColorSelected].
/// The available colors are pulled from [NoteCardColorsExtension] in the current theme.
class NoteColorPicker extends StatelessWidget {
  const NoteColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  /// Currently selected color name (one of [noteColorNames]), or `null` for default.
  final String? selectedColor;

  /// Called when the user taps a color swatch.
  final ValueChanged<String?> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColors = theme.extension<NoteCardColorsExtension>()!;
    final colors = noteColors.colors;
    final appColors = theme.extension<AppColorsExtension>()!;

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: colors.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = selectedColor == null;
            return _ColorSwatch(
              color: appColors.surface,
              isSelected: isSelected,
              borderColor: appColors.border,
              checkColor: appColors.textPrimary,
              showBorder: true,
              onTap: () => onColorSelected(null),
            );
          }

          final colorIndex = index - 1;
          final colorName = noteColorNames[colorIndex];
          final isSelected = selectedColor == colorName;

          return _ColorSwatch(
            color: colors[colorIndex],
            isSelected: isSelected,
            borderColor: appColors.border,
            checkColor: _contrastColor(colors[colorIndex]),
            onTap: () => onColorSelected(colorName),
          );
        },
      ),
    );
  }

  Color _contrastColor(Color bg) {
    return getContrastTextColor(bg);
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.isSelected,
    required this.borderColor,
    required this.checkColor,
    this.showBorder = false,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final Color borderColor;
  final Color checkColor;
  final bool showBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : (showBorder ? borderColor : color),
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check_rounded, size: 20, color: checkColor)
            : null,
      ),
    );
  }
}
