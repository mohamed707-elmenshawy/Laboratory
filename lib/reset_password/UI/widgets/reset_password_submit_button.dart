import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/reset_password_cubit.dart';

class ResetPasswordSubmitButton extends StatelessWidget {
  const ResetPasswordSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final ResetPasswordState state = context.watch<ResetPasswordCubit>().state;

    return AppButton(
      label: s.resetPasswordAction,
      loadingLabel: s.resettingPassword,
      successLabel: s.passwordResetDone,
      expand: true,
      size: AppButtonSize.large,
      isLoading: state is ResetPasswordLoading,
      isSuccess: state is ResetPasswordSuccess,
      onPressed: context.read<ResetPasswordCubit>().isBusy
          ? null
          : () {
              if (Form.of(context).validate()) {
                context.read<ResetPasswordCubit>().resetPassword();
              }
            },
    );
  }
}
