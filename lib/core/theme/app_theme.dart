import 'package:flutter/material.dart';

/
class AppTheme {
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color accentGreen = Color(0xFF00C853); // Voor success states
  static const Color warningRed = Color(0xFFE53935); // Voor fouten/waarschuwingen

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);


  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      
      colorScheme: const ColorScheme.light(
        primary: primaryBlack,
        onPrimary: primaryWhite,
        secondary: grey800,
        onSecondary: primaryWhite,
        error: warningRed,
        onError: primaryWhite,
        surface: primaryWhite,
        onSurface: primaryBlack,
      ),

      scaffoldBackgroundColor: grey50,

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryWhite,
        foregroundColor: primaryBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryBlack,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryBlack),
      ),

      
      cardTheme: CardThemeData(
        color: primaryWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: primaryWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlack,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlack,
          side: const BorderSide(color: grey300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: primaryWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlack, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: warningRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      dividerTheme: const DividerThemeData(
        color: grey200,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: primaryBlack,
        size: 24,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primaryWhite,
        selectedItemColor: primaryBlack,
        unselectedItemColor: grey500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlack,
        foregroundColor: primaryWhite,
        elevation: 4,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: grey100,
        deleteIconColor: grey600,
        labelStyle: const TextStyle(color: primaryBlack),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: primaryWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: grey900,
        contentTextStyle: const TextStyle(color: primaryWhite),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
