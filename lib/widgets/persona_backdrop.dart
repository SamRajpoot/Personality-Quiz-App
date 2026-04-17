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
    final base = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [base, Theme.of(context).colorScheme.surfaceContainer],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
