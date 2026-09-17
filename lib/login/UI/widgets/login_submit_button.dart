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
    final LoginState state = context.watch<LoginCubit>().state;

    return AppButton(
      label: s.signIn,
      loadingLabel: s.signingIn,
      successLabel: s.signedIn,
      expand: true,
      size: AppButtonSize.large,
      isLoading: state is LoginLoading,
      isSuccess: state is LoginSuccess,
      onPressed: context.read<LoginCubit>().isBusy
          ? null
          : () {
              if (Form.of(context).validate()) {
                context.read<LoginCubit>().login();
              }
            },
    );
  }
}
