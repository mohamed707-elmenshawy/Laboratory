import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/change_password_cubit.dart';

class ChangePasswordFeedbackBanner extends StatelessWidget {
  const ChangePasswordFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (BuildContext context, ChangePasswordState state) {
        final AppFeedback? feedback = switch (state) {
          ChangePasswordSuccess() => AppFeedback.success(
            title: s.passwordChangedTitle,
            message: s.passwordChangedMessage,
          ),
          ChangePasswordFailure(:final AppError error) => error.toFeedback(
            s,
            title: s.feedbackChangePasswordTitle,
          ),
          ChangePasswordInitial() || ChangePasswordLoading() => null,
        };

        return AnimatedSize(
          duration: AppMotion.resolve(context, AppMotion.base),
          curve: AppMotion.curve,
          alignment: AlignmentDirectional.topStart,
          child: feedback == null
              ? const SizedBox(width: double.infinity)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppAlert(
                      feedback: feedback,
                      onDismiss: () =>
                          context.read<ChangePasswordCubit>().dismissFeedback(),
                      dismissTooltip: s.dismiss,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
        );
      },
    );
  }
}
