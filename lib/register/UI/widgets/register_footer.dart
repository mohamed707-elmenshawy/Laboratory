import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/register_cubit.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool enabled = context.select(
      (RegisterCubit cubit) => cubit.state is! RegisterLoading,
    );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        children: <Widget>[
          Text(
            s.signInPrompt,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(fontSize: 13, color: AppColors.inkSubtle),
          ),
          AppTextLink(
            label: s.signInAction,
            onPressed: enabled ? () => Navigator.of(context).pop() : null,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
