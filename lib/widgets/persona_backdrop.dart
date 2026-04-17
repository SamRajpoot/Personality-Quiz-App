import 'dart:ui';

import 'package:flutter/material.dart';

class PersonaBackdrop extends StatelessWidget {
  const PersonaBackdrop({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Theme.of(context).scaffoldBackgroundColor;
    final tint1 = Color.lerp(base, scheme.primary, isDark ? 0.22 : 0.12) ?? base;
    final tint2 = Color.lerp(base, scheme.secondary, isDark ? 0.18 : 0.1) ?? base;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, tint1, tint2],
              stops: const [0.0, 0.58, 1.0],
            ),
          ),
        ),
        Positioned(
          top: -90,
          right: -40,
          child: _GlowBlob(
            color: scheme.primary.withValues(alpha: isDark ? 0.22 : 0.18),
            size: 250,
          ),
        ),
        Positioned(
          bottom: -90,
          left: -40,
          child: _GlowBlob(
            color: scheme.secondary.withValues(alpha: isDark ? 0.2 : 0.14),
            size: 280,
          ),
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
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
