import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const brightness = Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2F50FF),
      brightness: brightness,
      primary: const Color(0xFF2F50FF),
      onPrimary: Colors.white,
      secondary: const Color(0xFF0B95A8),
      secondaryContainer: const Color(0xFFE8F0FF),
      onSecondaryContainer: const Color(0xFF0F1F4A),
      surface: const Color(0xFFFFFFFF),
      surfaceContainer: const Color(0xFFF5F7FF),
      surfaceContainerHighest: const Color(0xFFEAF0FF),
      onSurface: const Color(0xFF111827),
      onSurfaceVariant: const Color(0xFF475569),
      outline: const Color(0xFFCBD5E1),
    );
    final baseText = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF7F9FF),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseText).copyWith(
        bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 16, color: const Color(0xFF111827)),
        bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 14, color: const Color(0xFF475569)),
        labelLarge: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF64748B)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF111827),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111827),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F50FF),
          foregroundColor: Colors.white,
          elevation: 1,
          shadowColor: const Color(0xFF2F50FF).withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E3A8A),
          side: const BorderSide(color: Color(0xFFB7C5FF), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFDCE5FF), width: 1),
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static ThemeData dark() {
    const brightness = Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF9DB0FF),
      brightness: brightness,
      primary: const Color(0xFFA9B8FF),
      onPrimary: const Color(0xFF0B1225),
      secondary: const Color(0xFF68D4E2),
      secondaryContainer: const Color(0xFF1B2752),
      onSecondaryContainer: const Color(0xFFEAF0FF),
      surface: const Color(0xFF0E1428),
      surfaceContainer: const Color(0xFF131C37),
      surfaceContainerHighest: const Color(0xFF1B2747),
      onSurface: const Color(0xFFEAF0FF),
      onSurfaceVariant: const Color(0xFFB7C4E8),
      outline: const Color(0xFF33456E),
    );
    final baseText = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF070D1D),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseText).copyWith(
        bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 16, color: const Color(0xFFEAF0FF)),
        bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 14, color: const Color(0xFFD6E0FF)),
        labelLarge: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF9FB0DC)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFFEAF0FF),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFEAF0FF),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA9B8FF),
          foregroundColor: const Color(0xFF0B1225),
          elevation: 1,
          shadowColor: const Color(0xFF5D78FF).withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFDDE6FF),
          side: const BorderSide(color: Color(0xFF4A5C88), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF121B34),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A3B63), width: 1),
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
