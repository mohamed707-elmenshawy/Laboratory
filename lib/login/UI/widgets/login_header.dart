import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool showLogo = !context.layoutSize.isExpanded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showLogo) ...<Widget>[
          AppLogoLockup(
            productName: s.productName,
            tagline: s.productTagline,
            onDark: false,
            markSize: 40,
            showTagline: false,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
        Text(s.signInTitle, style: base.merge(AppTypography.display)),
        const SizedBox(height: AppSpacing.xs + 3),
        Text(
          s.signInSubtitle,
          style: base
              .merge(AppTypography.body)
              .copyWith(fontSize: 14, color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}
