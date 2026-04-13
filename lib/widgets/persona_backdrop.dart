import 'dart:ui';

import 'package:flutter/material.dart';

class PersonaBackdrop extends StatelessWidget {
  const PersonaBackdrop({
    super.key,
    required this.child,
    this.hue = 268,
  });

  final Widget child;
  final double hue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c1 = HSVColor.fromAHSV(1, hue, 0.55, isDark ? 0.35 : 0.92).toColor();
    final c2 = HSVColor.fromAHSV(1, (hue + 40) % 360, 0.6, isDark ? 0.22 : 0.88).toColor();
    final c3 = HSVColor.fromAHSV(1, (hue + 140) % 360, 0.5, isDark ? 0.18 : 0.95).toColor();
    final base = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, c1.withValues(alpha: isDark ? 0.55 : 0.45), c2.withValues(alpha: isDark ? 0.45 : 0.35), c3.withValues(alpha: isDark ? 0.35 : 0.25)],
              stops: const [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _GlowBlob(color: c2.withValues(alpha: isDark ? 0.35 : 0.5), size: 220),
        ),
        Positioned(
          bottom: -60,
          left: -30,
          child: _GlowBlob(color: c3.withValues(alpha: isDark ? 0.3 : 0.45), size: 260),
        ),
        child,
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
