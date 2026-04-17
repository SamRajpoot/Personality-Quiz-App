import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? Colors.white.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.08);
    final fill = isDark ? scheme.surfaceContainer : scheme.surface;
    final card = ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: borderRadius,
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        splashColor: Colors.black.withValues(alpha: 0.08),
        highlightColor: Colors.black.withValues(alpha: 0.04),
        child: card,
      ),
    );
  }
}
