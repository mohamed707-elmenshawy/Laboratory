import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';

class LoginOptionsRow extends StatelessWidget {
  const LoginOptionsRow({super.key});

  static const double _stackBelow = 320;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool rememberMe = context.select(
      (LoginCubit cubit) => cubit.state.rememberMe,
    );
    final bool enabled = context.select(
      (LoginCubit cubit) => cubit.state.canSubmit,
    );

    final Widget remember = AppCheckbox(
      value: rememberMe,
      label: s.rememberMe,
      semanticHint: s.rememberMeHint,
      onChanged: enabled
          ? (bool value) =>
                context.read<LoginCubit>().onRememberMeChanged(value)
          : null,
    );

    final Widget forgot = AppTextLink(
      label: s.forgotPassword,
      onPressed: enabled ? _onForgotPassword : null,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < _stackBelow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              remember,
              const SizedBox(height: AppSpacing.sm),
              forgot,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[remember, forgot],
        );
      },
    );
  }

  void _onForgotPassword() {}
}
