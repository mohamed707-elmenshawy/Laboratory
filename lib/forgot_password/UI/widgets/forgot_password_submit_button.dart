import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/forgot_password_cubit.dart';

class ForgotPasswordSubmitButton extends StatelessWidget {
  const ForgotPasswordSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final ForgotPasswordState state = context
        .watch<ForgotPasswordCubit>()
        .state;

    return AppButton(
      label: s.sendResetLink,
      loadingLabel: s.sendingResetLink,
      successLabel: s.resetLinkSent,
      expand: true,
      size: AppButtonSize.large,
      isLoading: state is ForgotPasswordLoading,
      isSuccess: state is ForgotPasswordSuccess,
      onPressed: context.read<ForgotPasswordCubit>().isBusy
          ? null
          : () {
              if (Form.of(context).validate()) {
                context.read<ForgotPasswordCubit>().sendResetLink();
              }
            },
    );
  }
}
