import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/login_cubit.dart';
import '../../logic/login_state.dart';

class LoginFeedbackBanner extends StatelessWidget {
  const LoginFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (BuildContext context, LoginState state) {
        final AppFeedback? feedback = _feedbackFor(context, state, s);

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
                          context.read<LoginCubit>().dismissFailure(),
                      dismissTooltip: s.dismiss,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
        );
      },
    );
  }

  AppFeedback? _feedbackFor(
    BuildContext context,
    LoginState state,
    AppStrings s,
  ) {
    if (state.isSuccess) {
      return AppFeedback.success(
        title: s.feedbackSuccessTitle,
        message: s.signedInAs(state.response?.user.name ?? ''),
      );
    }

    final LoginFailureKind? failure = state.failure;
    if (failure == null) return null;

    return switch (failure) {
      LoginFailureKind.badCredentials => AppFeedback.danger(
        title: s.feedbackAuthTitle,
        message: state.serverMessage ?? s.serverErrorMessage,
      ),
      LoginFailureKind.accountUnverified => AppFeedback.warning(
        title: s.feedbackAccountTitle,
        message: state.serverMessage ?? s.serverErrorMessage,
        actionLabel: s.verifyEmailAction,
        onAction: _onVerifyEmail,
      ),
      LoginFailureKind.rateLimited => AppFeedback.warning(
        title: s.feedbackRateLimitTitle,
        message: s.rateLimitMessage(state.retryAfterSeconds ?? 0),
        icon: Icons.schedule_rounded,
      ),
      LoginFailureKind.server => AppFeedback.danger(
        title: s.feedbackServerTitle,
        message: state.serverMessage ?? s.serverErrorMessage,
        actionLabel: s.retry,
        onAction: () => context.read<LoginCubit>().submit(),
      ),
      LoginFailureKind.network => AppFeedback.danger(
        title: s.feedbackNetworkTitle,
        message: s.networkMessage,
        actionLabel: s.retry,
        onAction: () => context.read<LoginCubit>().submit(),
      ),
    };
  }

  void _onVerifyEmail() {}
}
