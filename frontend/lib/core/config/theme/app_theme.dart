import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colores oficiales de la Parroquia Cristo Resucitado
class AppColors {
  // Colores oficiales de la parroquia
  static const Color primaryRed = Color(0xFF8C2727); // Rojo principal
  static const Color parishGold = Color(0xFFD99A25); // Dorado parroquial
  static const Color lightGray = Color(0xFFF2F2F2); // Gris claro
  static const Color darkGray = Color(0xFF0D0D0D); // Negro/gris oscuro
  static const Color mediumGray = Color(0xFF454142); // Gris medio

  // Colores derivados para UI
  static const Color primaryColor = primaryRed;
  static const Color secondaryColor = parishGold;
  static const Color backgroundColor = lightGray;
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);

  // Colores para glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Colores de estado
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Colores de texto
  static const Color textPrimary = darkGray;
  static const Color textSecondary = mediumGray;
  static const Color textTertiary = Color(0xFF8E8E93);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Variaciones de los colores principales
  static const Color primaryLight = Color(0xFFB33A3A);
  static const Color primaryDark = Color(0xFF661D1D);
  static const Color goldLight = Color(0xFFE5B555);
  static const Color goldDark = Color(0xFFB8841A);

  // Colores para sombras y efectos
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowHeavy = Color(0x1F000000);

  // Gradientes con colores parroquiales
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryRed,
      primaryLight,
      primaryDark,
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      parishGold,
      goldLight,
      goldDark,
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lightGray,
      Color(0xFFFFFFFF),
    ],
  );

  // Alias para compatibilidad
  static const Color backgroundPrimary = lightGray;

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8F9FA),
    ],
  );
}

/// Tema de la aplicación con estilos iOS modernos
class AppTheme {
  // Bordes redondeados modernos
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // Espaciado consistente
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Sombras modernas tipo iOS
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: AppColors.shadowLight,
          offset: Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: AppColors.shadowMedium,
          offset: Offset(0, 1),
          blurRadius: 2,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: AppColors.shadowMedium,
          offset: Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -1,
        ),
        BoxShadow(
          color: AppColors.shadowLight,
          offset: Offset(0, 2),
          blurRadius: 4,
          spreadRadius: -1,
        ),
      ];

  static List<BoxShadow> get strongShadow => [
        BoxShadow(
          color: AppColors.shadowHeavy,
          offset: Offset(0, 10),
          blurRadius: 15,
          spreadRadius: -3,
        ),
        BoxShadow(
          color: AppColors.shadowMedium,
          offset: Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -2,
        ),
      ];

  // Decoración para cards glassmorphism
  static BoxDecoration get glassCard => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: mediumShadow,
      );

  // Estilos de texto modernos con Montserrat
  static TextStyle get headingLarge => GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headingMedium => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle get headingSmall => GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
      );

  static TextStyle get bodyLarge => GoogleFonts.montserrat(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.4,
      );

  static TextStyle get bodyMedium => GoogleFonts.montserrat(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.3,
      );

  /// Tema completo de Material para la aplicación
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          surface: AppColors.surfaceColor,
          background: AppColors.backgroundColor,
        ),
        textTheme: TextTheme(
          displayLarge: headingLarge,
          displayMedium: headingMedium,
          displaySmall: headingSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: caption,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: headingSmall.copyWith(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          shadowColor: AppColors.shadowMedium,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: spacingL,
              vertical: spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSmall),
            ),
            textStyle: bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
            borderSide:
                BorderSide(color: AppColors.mediumGray.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
            borderSide:
                BorderSide(color: AppColors.mediumGray.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
        ),
      );
}
