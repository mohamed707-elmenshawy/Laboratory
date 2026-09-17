import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData light({required bool arabic}) {
    final String family = arabic
        ? AppTextStyles.familyArabic
        : AppTextStyles.family;
    final List<String> fallback = arabic
        ? AppTextStyles.fallbackArabic
        : AppTextStyles.fallback;

    final ColorScheme scheme = const ColorScheme.light().copyWith(
      primary: AppColors.brand600,
      onPrimary: AppColors.onBrand,
      primaryContainer: AppColors.brandWash,
      onPrimaryContainer: AppColors.brand900,
      secondary: AppColors.brand500,
      onSecondary: AppColors.onBrand,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceContainerHighest: AppColors.surfaceMuted,
      error: AppColors.danger,
      onError: AppColors.onBrand,
      errorContainer: AppColors.dangerWash,
      onErrorContainer: AppColors.danger,
      outline: AppColors.lineStrong,
      outlineVariant: AppColors.line,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.ground,
      fontFamily: family,
      fontFamilyFallback: fallback,
      splashFactory: NoSplash.splashFactory,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.brand600,
        selectionColor: AppColors.brandWash,
        selectionHandleColor: AppColors.brand600,
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: AppRadius.smAll,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: AppTextStyles.caption.copyWith(
          color: AppColors.onBrand,
          fontFamily: family,
          fontFamilyFallback: fallback,
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: AppTextStyles.display,
        headlineSmall: AppTextStyles.h2,
        titleMedium: AppTextStyles.h3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.label,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
