import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Theme class to manage colors and styles throughout the app
class AppTheme {
  // Light theme colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color cardColor = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);
  
  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF8267BE);
  static const Color darkCardColor = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFE1E1E1);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  
  /// Returns color based on brightness
  static Color getColor(BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.light ? lightColor : darkColor;
  }
  
  /// Get text theme based on brightness
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme.apply(
      bodyColor: getColor(context, textPrimary, darkTextPrimary),
      displayColor: getColor(context, textPrimary, darkTextPrimary),
    );
  }

  /// Get theme data based on dark mode flag
  static ThemeData getThemeData(bool isDarkMode) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final primaryColorValue = isDarkMode ? darkPrimaryColor : primaryColor;
    
    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColorValue,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: accentColor,
        brightness: brightness,
      ),
      cardColor: isDarkMode ? darkCardColor : cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? Colors.grey[850] : primaryColor,
        elevation: 0,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
    );
  }
} 