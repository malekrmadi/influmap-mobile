import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Theme class to manage colors and styles throughout the app
class AppTheme {
  // Light theme colors
  static const Color primaryColor = Color(0xFF5E60CE); // Modern purple
  static const Color accentColor = Color(0xFF64DFDF); // Turquoise
  static const Color cardColor = Color(0xFFF8F9FA); // Light gray
  static const Color textPrimary = Color(0xFF2B2D42); // Dark blue-gray
  static const Color textSecondary = Color(0xFF6C757D); // Medium gray
  static const Color dividerColor = Color(0xFFDEE2E6); // Light gray
  static const Color successColor = Color(0xFF56C596); // Green
  static const Color errorColor = Color(0xFFEF476F); // Pink-red
  static const Color warningColor = Color(0xFFFFD166); // Yellow
  
  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF7B78FF); // Lighter purple
  static const Color darkAccentColor = Color(0xFF72EFDD); // Lighter turquoise
  static const Color darkCardColor = Color(0xFF2D3142); // Dark blue-gray
  static const Color darkTextPrimary = Color(0xFFF8F9FA); // Light gray
  static const Color darkTextSecondary = Color(0xFFADB5BD); // Medium gray
  static const Color darkDividerColor = Color(0xFF495057); // Dark gray
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF6930C3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFF80FFDB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [darkPrimaryColor, Color(0xFF5E60CE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
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
    final backgroundColor = isDarkMode ? Color(0xFF1A1A2E) : Colors.white;
    
    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColorValue,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColorValue,
        secondary: isDarkMode ? darkAccentColor : accentColor,
        brightness: brightness,
        error: errorColor,
      ),
      cardColor: isDarkMode ? darkCardColor : cardColor,
      dividerColor: isDarkMode ? darkDividerColor : dividerColor,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? Color(0xFF1A1A2E) : primaryColorValue,
        elevation: 0,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? darkTextPrimary : Colors.white,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDarkMode ? darkTextPrimary : textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorValue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColorValue,
          side: BorderSide(color: primaryColorValue),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColorValue,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkMode ? Color(0xFF2D3142).withOpacity(0.7) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDarkMode ? darkDividerColor : dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColorValue, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
  
  // Box decoration for cards with hover effect
  static BoxDecoration getCardDecoration(BuildContext context, {bool isHovered = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? darkPrimaryColor : AppTheme.primaryColor;
    
    return BoxDecoration(
      color: isDark ? darkCardColor : cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isHovered
              ? primaryColor.withOpacity(0.3)
              : Colors.black.withOpacity(isDark ? 0.3 : 0.1),
          blurRadius: isHovered ? 12 : 6,
          offset: Offset(0, isHovered ? 4 : 2),
          spreadRadius: isHovered ? 2 : 0,
        ),
      ],
    );
  }
} 