import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';

class LaboratoryStatusPill extends StatelessWidget {
  const LaboratoryStatusPill({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    final Color foreground = isActive ? AppColors.success : AppColors.inkSubtle;
    final Color background = isActive
        ? AppColors.successWash
        : AppColors.surfaceMuted;
    final Color border = isActive ? AppColors.successLine : AppColors.line;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.pill,
        border: Border.all(color: border, width: AppSizes.borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isActive
                ? Icons.check_circle_rounded
                : Icons.pause_circle_outline_rounded,
            size: AppSizes.iconSm,
            color: foreground,
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Flexible(
            child: Text(
              isActive ? s.statusActive : s.statusInactive,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: foreground,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
