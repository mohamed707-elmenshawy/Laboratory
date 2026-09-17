import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../register/UI/register_screen.dart';
import '../../logic/login_cubit.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool enabled = context.select((LoginCubit cubit) => !cubit.isBusy);

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        children: <Widget>[
          Text(
            s.registerPrompt,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(fontSize: 13, color: AppColors.inkSubtle),
          ),
          AppTextLink(
            label: s.registerAction,
            onPressed: enabled ? () => _onRegister(context) : null,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  void _onRegister(BuildContext context) =>
      Navigator.of(context).push(RegisterScreen.route());
}
