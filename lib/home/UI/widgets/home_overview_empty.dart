import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';

class HomeOverviewEmpty extends StatelessWidget {
  const HomeOverviewEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.x4l,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_outlined,
              size: AppSizes.iconLg,
              color: AppColors.inkSubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            s.overviewEmptyTitle,
            textAlign: TextAlign.center,
            style: base
                .merge(AppTextStyles.h3)
                .copyWith(fontSize: 16, color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            s.overviewEmptyMessage,
            textAlign: TextAlign.center,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(color: AppColors.inkSubtle),
          ),
        ],
      ),
    );
  }
}
