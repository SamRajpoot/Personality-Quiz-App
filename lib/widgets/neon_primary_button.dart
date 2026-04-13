import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NeonPrimaryButton extends StatelessWidget {
  const NeonPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      shadowColor: scheme.primary.withValues(alpha: 0.55),
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
    );
    final text = Text(label, style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2));
    final child = icon == null
        ? FilledButton(style: style, onPressed: onPressed, child: text)
        : FilledButton.icon(
            style: style,
            onPressed: onPressed,
            icon: Icon(icon, size: 22),
            label: text,
          )
        .animate(target: onPressed == null ? 0 : 1)
        .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1), duration: 180.ms, curve: Curves.easeOutBack);
    if (!expand) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}
