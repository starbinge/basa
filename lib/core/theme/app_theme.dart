import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  AppTheme._();

  static const _fredoka = 'Fredoka';
  static const _jakartaSans = 'PlusJakartaSans';

  static ThemeData light(BuildContext context) {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      inversePrimary: AppColors.inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fredoka,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,

      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: _fredoka,
          fontSize: 51.sp,
          fontWeight: FontWeight.w700,
          height: 1.1,
          letterSpacing: -1.28,
          color: AppColors.onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: _fredoka,
          fontSize: 45.sp,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -1.0,
          color: AppColors.onSurface,
        ),
        displaySmall: TextStyle(
          fontFamily: _fredoka,
          fontSize: 36.sp,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.5,
          color: AppColors.onSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: _fredoka,
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.4,
          color: AppColors.onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fredoka,
          fontSize: 19.sp,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontFamily: _fredoka,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleMedium: TextStyle(
          fontFamily: _fredoka,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleSmall: TextStyle(
          fontFamily: _fredoka,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: _jakartaSans,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: _jakartaSans,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: AppColors.onSurface,
        ),
        bodySmall: TextStyle(
          fontFamily: _jakartaSans,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          height: 1.4,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontFamily: _fredoka,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          height: 1.0,
          letterSpacing: 0.7,
          color: AppColors.onSurface,
        ),
        labelMedium: TextStyle(
          fontFamily: _fredoka,
          fontSize: 9.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: AppColors.onSurface,
        ),
        labelSmall: TextStyle(
          fontFamily: _fredoka,
          fontSize: 8.sp,
          fontWeight: FontWeight.w400,
          height: 1.0,
          color: AppColors.onSurface,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 1,
          shadowColor: Colors.black.withAlpha(25),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.outline, width: 1.w),
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          textStyle: const TextStyle(
            fontFamily: _fredoka,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          shadowColor: Colors.transparent,
          side: BorderSide(color: AppColors.outline, width: 1.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          textStyle: const TextStyle(
            fontFamily: _fredoka,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.all(8.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: AppColors.outline, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: AppColors.onSurface, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: AppColors.error, width: 1.5.w),
        ),
        labelStyle: TextStyle(
          fontFamily: _fredoka,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          fontFamily: _fredoka,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceVariant.withAlpha(100),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        elevation: 2,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: _fredoka,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: _fredoka,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.outlineVariant, width: 1.w),
          borderRadius: BorderRadius.circular(4.r),
        ),
        color: AppColors.surfaceContainerLow,
        margin: EdgeInsets.zero,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 1,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: _fredoka,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),

      dividerTheme: DividerThemeData(
        thickness: 1,
        color: AppColors.outlineVariant,
        space: 1,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primary,
        labelStyle: TextStyle(
          fontFamily: _fredoka,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.onPrimary,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceContainerHighest,
      ),

      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
    );
  }
}
