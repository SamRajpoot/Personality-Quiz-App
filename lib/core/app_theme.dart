import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const brightness = Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C3AED),
      brightness: brightness,
      primary: const Color(0xFF6D28D9),
      secondary: const Color(0xFF0EA5E9),
      surface: const Color(0xFFF4F6FF),
    );
    final baseText = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFEEF2FF),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseText),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static ThemeData dark() {
    const brightness = Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6),
      brightness: brightness,
      primary: const Color(0xFFA78BFA),
      secondary: const Color(0xFF22D3EE),
      surface: const Color(0xFF0F172A),
    );
    final baseText = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0B1020),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseText),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
