import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';

class LoginTopBar extends StatelessWidget {
  const LoginTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool enabled = context.select(
      (LoginCubit cubit) => cubit.state.canSubmit,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        AppLanguageSwitcher(
          value: context.appLocale,
          onChanged: context.setAppLocale,
          semanticLabel: s.languageSwitcherLabel,
          enabled: enabled,
        ),
      ],
    );
  }
}
