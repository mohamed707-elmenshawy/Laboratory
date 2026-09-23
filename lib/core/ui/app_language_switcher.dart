import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';
import '../localization/app_locale.dart';
import '../localization/app_localization.dart';

class AppLanguageSwitcher extends StatelessWidget {
  const AppLanguageSwitcher({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.enabled = true,
  });

  final AppLocale value;
  final ValueChanged<AppLocale> onChanged;
  final String semanticLabel;
  final bool enabled;

  List<AppLocale> _itemsOf(BuildContext context) {
    final List<AppLocale> available = context.labSettings.availableLocales;
    final List<AppLocale> locales = available.isEmpty
        ? AppLocale.values
        : available;

    if (locales.contains(value)) return locales;
    return <AppLocale>[value, ...locales];
  }

  TextStyle _styleFor(AppLocale locale) {
    return AppTextStyles.label.copyWith(
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: AppColors.inkMuted,
      fontFamily: locale.isRtl
          ? AppTextStyles.familyArabic
          : AppTextStyles.family,
      fontFamilyFallback: locale.isRtl
          ? AppTextStyles.fallbackArabic
          : AppTextStyles.fallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AppLocale> items = _itemsOf(context);

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: enabled,
      child: Container(
        height: AppSizes.controlSmall,
        padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: AppColors.line,
            width: AppSizes.borderWidth,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<AppLocale>(
            value: value,
            isDense: true,
            borderRadius: AppRadius.mdAll,
            dropdownColor: AppColors.surface,
            focusColor: const Color(0x00000000),
            icon: const Padding(
              padding: EdgeInsetsDirectional.only(end: AppSpacing.xs),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: AppSizes.iconMd,
                color: AppColors.inkSubtle,
              ),
            ),
            style: _styleFor(value),
            items: items
                .map(
                  (AppLocale locale) => DropdownMenuItem<AppLocale>(
                    value: locale,
                    child: Text(locale.nativeName, style: _styleFor(locale)),
                  ),
                )
                .toList(growable: false),
            onChanged: enabled
                ? (AppLocale? locale) {
                    if (locale != null) onChanged(locale);
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
