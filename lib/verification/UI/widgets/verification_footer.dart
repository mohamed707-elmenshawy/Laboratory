import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/verification_cubit.dart';

class VerificationFooter extends StatelessWidget {
  const VerificationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool enabled = context.select(
      (VerificationCubit cubit) => cubit.state is! VerificationLoading,
    );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xs,
        children: <Widget>[
          Text(
            s.verifiedPrompt,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(fontSize: 13, color: AppColors.inkSubtle),
          ),
          AppTextLink(
            label: s.signInAction,
            onPressed: enabled
                ? () => Navigator.of(
                    context,
                  ).popUntil((Route<dynamic> route) => route.isFirst)
                : null,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
