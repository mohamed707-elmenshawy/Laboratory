import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/update_profile_cubit.dart';

class ProfileFeedbackBanner extends StatelessWidget {
  const ProfileFeedbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      builder: (BuildContext context, UpdateProfileState state) {
        final AppFeedback? feedback = switch (state) {
          UpdateProfileSuccess() => AppFeedback.success(
            title: s.profileUpdatedTitle,
            message: s.profileUpdatedMessage,
          ),
          UpdateProfileFailure(:final AppError error) => error.toFeedback(
            s,
            title: s.feedbackProfileTitle,
          ),
          UpdateProfileInitial() || UpdateProfileLoading() => null,
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
                          context.read<UpdateProfileCubit>().dismissFeedback(),
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
