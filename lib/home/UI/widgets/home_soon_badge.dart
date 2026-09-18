import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';

class HomeSoonBadge extends StatelessWidget {
  const HomeSoonBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.pill,
      ),
      child: Text(
        context.strings.soon,
        style: base
            .merge(AppTextStyles.caption)
            .copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.inkSubtle,
            ),
      ),
    );
  }
}
