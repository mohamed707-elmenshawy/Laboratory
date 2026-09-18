import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/user_model.dart';

class HomeWelcomeHeader extends StatelessWidget {
  const HomeWelcomeHeader({super.key, required this.user});

  final UserModel user;

  String get _firstName {
    final List<String> parts = user.name.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? user.name : parts.first;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          s.welcomeBack(_firstName),
          style: base.merge(AppTextStyles.h2).copyWith(color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          s.homeSubtitle,
          style: base
              .merge(AppTextStyles.body)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}
