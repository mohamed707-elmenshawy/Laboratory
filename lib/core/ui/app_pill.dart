import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';

enum AppPillTone { success, neutral, brand, warning }

class AppPill extends StatelessWidget {
  const AppPill({
    super.key,
    required this.label,
    this.tone = AppPillTone.neutral,
    this.icon,
  });

  final String label;
  final AppPillTone tone;
  final IconData? icon;

  Color get _foreground => switch (tone) {
    AppPillTone.success => AppColors.success,
    AppPillTone.neutral => AppColors.inkSubtle,
    AppPillTone.brand => AppColors.brand700,
    AppPillTone.warning => AppColors.warning,
  };

  Color get _background => switch (tone) {
    AppPillTone.success => AppColors.successWash,
    AppPillTone.neutral => AppColors.surfaceMuted,
    AppPillTone.brand => AppColors.brandWash,
    AppPillTone.warning => AppColors.warningWash,
  };

  Color get _border => switch (tone) {
    AppPillTone.success => AppColors.successLine,
    AppPillTone.neutral => AppColors.line,
    AppPillTone.brand => AppColors.brandLine,
    AppPillTone.warning => AppColors.warningLine,
  };

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: AppRadius.pill,
        border: Border.all(color: _border, width: AppSizes.borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: AppSizes.iconSm, color: _foreground),
            const SizedBox(width: AppSpacing.xs + 2),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _foreground,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
