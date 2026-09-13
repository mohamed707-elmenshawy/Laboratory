import 'package:flutter/widgets.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const String family = 'IBM Plex Sans';
  static const String familyArabic = 'IBM Plex Sans Arabic';

  static const List<String> fallback = <String>[familyArabic];
  static const List<String> fallbackArabic = <String>[family];

  static const TextStyle display = TextStyle(
    fontSize: 28,
    height: 1.21,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.56,
    color: AppColors.ink,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    height: 1.36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.26,
    color: AppColors.ink,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    height: 1.44,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    height: 1.6,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    height: 1.57,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    height: 1.38,
    fontWeight: FontWeight.w500,
    color: AppColors.inkMuted,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.inkSubtle,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.08,
  );
}
