import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../forgot_password/logic/forgot_password_cubit.dart';

class ChangePasswordResetLinkCard extends StatelessWidget {
  const ChangePasswordResetLinkCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
    final String email = cubit.emailController.text;

    return AppCard(
      child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
        builder: (BuildContext context, ForgotPasswordState state) {
          final AppFeedback? feedback = switch (state) {
            ForgotPasswordSuccess(:final String email) => AppFeedback.success(
              title: s.resetLinkSentTitle,
              message: s.resetLinkSentMessage(email),
            ),
            ForgotPasswordFailure(:final AppError error) => error.toFeedback(
              s,
              title: s.feedbackForgotPasswordTitle,
            ),
            ForgotPasswordInitial() || ForgotPasswordLoading() => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                s.forgotCurrentPasswordTitle,
                style: base
                    .merge(AppTextStyles.label)
                    .copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs + 2),
              Text(
                s.resetLinkExplainer(email),
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(color: AppColors.inkSubtle),
              ),
              const SizedBox(height: AppSpacing.lg),
              AnimatedSize(
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
                            onDismiss: state is ForgotPasswordFailure
                                ? cubit.dismissFailure
                                : null,
                            dismissTooltip: s.dismiss,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
              ),
              AppButton(
                label: s.emailMeResetLink,
                loadingLabel: s.sendingResetLink,
                successLabel: s.resetLinkSent,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.medium,
                isLoading: state is ForgotPasswordLoading,
                isSuccess: state is ForgotPasswordSuccess,
                onPressed: cubit.isBusy ? null : cubit.sendResetLink,
              ),
            ],
          );
        },
      ),
    );
  }
}
