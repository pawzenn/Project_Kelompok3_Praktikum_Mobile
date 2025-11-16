// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF36A36A)),
      scaffoldBackgroundColor: const Color(0xFFF3F8F2),
      appBarTheme: const AppBarTheme(centerTitle: true),

      // ✅ Sesuai API terbaru: CardThemeData (bukan CardTheme)
      cardTheme: CardThemeData(
        color: const Color(0xFFEFF7EC),
        elevation: 0,
        margin: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
