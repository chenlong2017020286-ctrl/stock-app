import 'package:flutter/material.dart';

class AppTheme {
  static const Color up = Color(0xFFE53935);    // 涨-红色（A股惯例）
  static const Color down = Color(0xFF43A047);  // 跌-绿色
  static const Color primary = Color(0xFF1A237E);
  static const Color accent = Color(0xFF304FFE);
  static const Color background = Color(0xFFF5F6FA);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primary,
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: textPrimary,
          titleTextStyle: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          clipBehavior: Clip.antiAlias,
          color: cardBg,
        ),
        navigationBarTheme: NavigationBarThemeData(
          elevation: 2,
          backgroundColor: Colors.white,
          indicatorColor: primary.withValues(alpha: 0.1),
          labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      );
}
