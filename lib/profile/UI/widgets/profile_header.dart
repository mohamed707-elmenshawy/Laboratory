import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          s.profileTitle,
          style: base.merge(AppTextStyles.h2).copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          s.profileSubtitle,
          style: base
              .merge(AppTextStyles.body)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}
