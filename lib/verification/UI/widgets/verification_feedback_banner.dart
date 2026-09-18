import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/verification_cubit.dart';

class VerificationFeedbackBanner extends StatelessWidget {
  const VerificationFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<VerificationCubit, VerificationState>(
      builder: (BuildContext context, VerificationState state) {
        final AppFeedback? feedback = switch (state) {
          VerificationSuccess() => AppFeedback.success(
            title: s.verificationSuccessTitle,
            message: s.verificationSuccessMessage,
            actionLabel: s.signInAction,
            onAction: () => Navigator.of(
              context,
            ).popUntil((Route<dynamic> route) => route.isFirst),
          ),
          VerificationFailure(:final AppError error) => error.toFeedback(
            s,
            title: s.feedbackVerificationTitle,
          ),
          VerificationInitial() || VerificationLoading() => null,
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
                      onDismiss: state is VerificationSuccess
                          ? null
                          : () => context
                                .read<VerificationCubit>()
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
