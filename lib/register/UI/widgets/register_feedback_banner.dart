import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../verification/UI/verification_screen.dart';
import '../../data/models/register_response.dart';
import '../../logic/register_cubit.dart';

class RegisterFeedbackBanner extends StatelessWidget {
  const RegisterFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (BuildContext context, RegisterState state) {
        final AppFeedback? feedback = switch (state) {
          RegisterSuccess(:final RegisterResponse response) =>
            AppFeedback.success(
              title: s.registerSuccessTitle,
              message: s.registerSuccessMessage(response.email),
              actionLabel: s.verifyEmailAction,
              onAction: () => Navigator.of(
                context,
              ).push(VerificationScreen.route(email: response.email)),
            ),
          RegisterFailure(:final AppError error) => error.toFeedback(
            s,
            title: s.feedbackRegisterTitle,
          ),
          RegisterInitial() || RegisterLoading() => null,
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
                      onDismiss: state is RegisterSuccess
                          ? null
                          : () =>
                                context.read<RegisterCubit>().dismissFailure(),
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
