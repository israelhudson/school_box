import 'package:flutter/material.dart';

class SchoolTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF2E7D32); // Verde escuro
  static const Color secondaryColor = Color(0xFF4CAF50); // Verde médio
  static const Color accentColor = Color(0xFF81C784); // Verde claro
  static const Color backgroundColor = Color(
    0xFF15202B,
  ); // Azul escuro (estilo X)
  static const Color surfaceColor = Color(
    0xFF192734,
  ); // Azul mais claro para superfícies
  static const Color textColor = Color(0xFFE1E8ED); // Texto claro
  static const Color textSecondaryColor = Color(0xFF8899A6); // Texto secundário

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      onSurface: textColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: surfaceColor,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      labelLarge: TextStyle(
        fontSize: 18,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      labelStyle: TextStyle(color: textSecondaryColor),
      prefixIconColor: secondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: textSecondaryColor.withValues(alpha: 0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: textSecondaryColor.withValues(alpha: 0.3),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: secondaryColor),
    ),
    iconTheme: IconThemeData(color: textColor),
  );
}
