import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';

class LoginOptionsRow extends StatefulWidget {
  const LoginOptionsRow({super.key});

  @override
  State<LoginOptionsRow> createState() => _LoginOptionsRowState();
}

class _LoginOptionsRowState extends State<LoginOptionsRow> {
  static const double _stackBelow = 320;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool enabled = context.select((LoginCubit cubit) => !cubit.isBusy);

    final Widget remember = AppCheckbox(
      value: context.read<LoginCubit>().rememberMe,
      label: s.rememberMe,
      semanticHint: s.rememberMeHint,
      onChanged: enabled
          ? (bool value) =>
                setState(() => context.read<LoginCubit>().rememberMe = value)
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
