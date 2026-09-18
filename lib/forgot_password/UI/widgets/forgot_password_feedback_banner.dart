import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/forgot_password_cubit.dart';

class ForgotPasswordFeedbackBanner extends StatelessWidget {
  const ForgotPasswordFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (BuildContext context, ForgotPasswordState state) {
        final AppFeedback? feedback = switch (state) {
          ForgotPasswordSuccess(:final String email) => AppFeedback.success(
            title: s.resetLinkSentTitle,
            message: s.resetLinkSentMessage(email),
            actionLabel: s.signInAction,
            onAction: () => Navigator.of(
              context,
            ).popUntil((Route<dynamic> route) => route.isFirst),
          ),
          ForgotPasswordFailure(:final AppError error) => error.toFeedback(
            s,
            title: s.feedbackForgotPasswordTitle,
          ),
          ForgotPasswordInitial() || ForgotPasswordLoading() => null,
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
                      onDismiss: state is ForgotPasswordSuccess
                          ? null
                          : () => context
                                .read<ForgotPasswordCubit>()
                                .dismissFailure(),
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
