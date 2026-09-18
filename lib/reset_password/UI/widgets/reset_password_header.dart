import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/reset_password_cubit.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool showLogo = !context.layoutSize.isExpanded;
    final String email = context.read<ResetPasswordCubit>().link.email;

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
        Text(s.resetPasswordTitle, style: base.merge(AppTextStyles.display)),
        const SizedBox(height: AppSpacing.xs + 3),
        Text(
          s.resetPasswordSubtitle(email),
          style: base
              .merge(AppTextStyles.body)
              .copyWith(fontSize: 14, color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}
