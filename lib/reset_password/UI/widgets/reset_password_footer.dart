import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../forgot_password/UI/forgot_password_screen.dart';
import '../../logic/reset_password_cubit.dart';

class ResetPasswordFooter extends StatelessWidget {
  const ResetPasswordFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool enabled = context.select(
      (ResetPasswordCubit cubit) => cubit.state is! ResetPasswordLoading,
    );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        children: <Widget>[
          Text(
            s.linkExpiredPrompt,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(fontSize: 13, color: AppColors.inkSubtle),
          ),
          AppTextLink(
            label: s.requestNewLink,
            onPressed: enabled
                ? () => Navigator.of(context).push(
                    ForgotPasswordScreen.route(
                      email: context.read<ResetPasswordCubit>().link.email,
                    ),
                  )
                : null,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
