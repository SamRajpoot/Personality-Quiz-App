import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.height = 10,
  });

  final int current;
  final int total;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = total <= 0 ? 0.0 : (current / total).clamp(0.0, 1.0);
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: t),
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              final fill = (w * value).clamp(0.0, w);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: w,
                    height: height,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
                    ),
                  ),
                  Container(
                    width: fill,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: LinearGradient(
                        colors: [scheme.primary, scheme.secondary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.45),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    ).animate().fadeIn(duration: 250.ms);
  }
}
