import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData light() {
    const brightness = Brightness.light;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF111111),
      brightness: brightness,
      primary: const Color(0xFF111111),
      onPrimary: Colors.white,
      secondary: const Color(0xFF6B7280),
      surface: const Color(0xFFFFFFFF),
      surfaceContainer: const Color(0xFFF2F2F2),
      surfaceContainerHighest: const Color(0xFFE8E8E8),
      onSurface: const Color(0xFF111111),
      onSurfaceVariant: const Color(0xFF404040),
      outline: const Color(0xFFBDBDBD),
    );
    final baseText = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseText).copyWith(
        bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 16, color: const Color(0xFF111111)),
        bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 14, color: const Color(0xFF404040)),
        labelLarge: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF6B6B6B)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF111111),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF111111),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF111111),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF111111),
          side: const BorderSide(color: Color(0xFF111111), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }

  static ThemeData dark() {
    const brightness = Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE5E5E5),
      brightness: brightness,
      primary: const Color(0xFFE5E5E5),
      onPrimary: const Color(0xFF111111),
      secondary: const Color(0xFF6B7280),
      surface: const Color(0xFF111111),
      surfaceContainer: const Color(0xFF1A1A1A),
      surfaceContainerHighest: const Color(0xFF262626),
      onSurface: const Color(0xFFF5F5F5),
      onSurfaceVariant: const Color(0xFFCACACA),
      outline: const Color(0xFF4B4B4B),
    );
    final baseText = ThemeData(brightness: brightness).textTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF000000),
      textTheme: GoogleFonts.spaceGroteskTextTheme(baseText).copyWith(
        bodyLarge: GoogleFonts.spaceGrotesk(fontSize: 16, color: const Color(0xFFF5F5F5)),
        bodyMedium: GoogleFonts.spaceGrotesk(fontSize: 14, color: const Color(0xFFE5E5E5)),
        labelLarge: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFB3B3B3)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFFF5F5F5),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF5F5F5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5F5F5),
          foregroundColor: const Color(0xFF111111),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF5F5F5),
          side: const BorderSide(color: Color(0xFFF5F5F5), width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF111111),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF2A2A2A), width: 1),
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
