import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool isSubmitting = context.select(
      (LoginCubit cubit) => cubit.state.isSubmitting,
    );
    final bool isSuccess = context.select(
      (LoginCubit cubit) => cubit.state.isSuccess,
    );
    final bool enabled = context.select(
      (LoginCubit cubit) => cubit.state.canSubmit,
    );

    return AppButton(
      label: s.signIn,
      loadingLabel: s.signingIn,
      successLabel: s.signedIn,
      expand: true,
      size: AppButtonSize.large,
      isLoading: isSubmitting,
      isSuccess: isSuccess,
      onPressed: enabled ? () => context.read<LoginCubit>().submit() : null,
    );
  }
}
