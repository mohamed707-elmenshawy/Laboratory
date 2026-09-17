import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/login_response.dart';
import '../../logic/login_cubit.dart';

class LoginFeedbackBanner extends StatelessWidget {
  const LoginFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (BuildContext context, LoginState state) {
        final AppFeedback? feedback = switch (state) {
          LoginSuccess(:final LoginResponse response) => AppFeedback.success(
            title: s.feedbackSuccessTitle,
            message: s.signedInAs(response.user.name),
          ),
          LoginFailure(:final AppError error) => error.toFeedback(
            s,
            title: s.feedbackAuthTitle,
          ),
          LoginInitial() || LoginLoading() => null,
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
}
