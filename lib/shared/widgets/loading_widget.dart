import 'package:flutter/material.dart';

/// Full-page or inline loading indicator using the brand primary color.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.fullPage = true, this.size = 36.0});

  /// When true, centers the indicator on the full available space.
  final bool fullPage;

  /// Diameter of the progress indicator.
  final double size;

  /// Convenience constructor for an inline (non-expanding) variant.
  const LoadingWidget.inline({super.key})
      : fullPage = false,
        size = 24.0;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    if (!fullPage) return Center(child: indicator);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: indicator,
      ),
    );
  }
}
