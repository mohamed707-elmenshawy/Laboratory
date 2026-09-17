import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/register_cubit.dart';

class RegisterTopBar extends StatelessWidget {
  const RegisterTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool enabled = context.select((RegisterCubit cubit) => !cubit.isBusy);

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
