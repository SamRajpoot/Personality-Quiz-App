import 'package:flutter/material.dart';

IconData iconFromName(String name) {
  switch (name) {
    case 'nights_stay':
      return Icons.nights_stay_rounded;
    case 'work_outline':
      return Icons.work_outline_rounded;
    case 'favorite_outline':
      return Icons.favorite_outline_rounded;
    case 'military_tech':
      return Icons.military_tech_rounded;
    case 'auto_awesome':
      return Icons.auto_awesome_rounded;
    case 'psychology':
      return Icons.psychology_rounded;
    default:
      return Icons.quiz_rounded;
  }
}
