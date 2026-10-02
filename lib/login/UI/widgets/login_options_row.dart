import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../forgot_password/UI/forgot_password_screen.dart';
import '../../logic/login_cubit.dart';

class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final bool enabled = context.select((LoginCubit cubit) => !cubit.isBusy);

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: AppTextLink(
        label: context.strings.forgotPassword,
        onPressed: enabled ? () => _onForgotPassword(context) : null,
      ),
    );
  }

  void _onForgotPassword(BuildContext context) => Navigator.of(context).push(
    ForgotPasswordScreen.route(
      email: context.read<LoginCubit>().emailController.text.trim(),
    ),
  );
}
