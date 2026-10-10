import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/user_model.dart';
import '../../logic/delete_user_cubit.dart';

class UserDeleteDialog extends StatelessWidget {
  const UserDeleteDialog({super.key, required this.user});

  final UserModel user;

  static Future<bool> show(BuildContext context, UserModel user) async {
    final bool? deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<DeleteUserCubit>(
        create: (_) => getIt<DeleteUserCubit>(),
        child: UserDeleteDialog(user: user),
      ),
    );

    return deleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocConsumer<DeleteUserCubit, DeleteUserState>(
      listenWhen: (DeleteUserState previous, DeleteUserState next) =>
          next is DeleteUserSuccess,
      listener: (BuildContext context, DeleteUserState state) =>
          Navigator.of(context).pop(true),
      builder: (BuildContext context, DeleteUserState state) {
        final DeleteUserCubit cubit = context.read<DeleteUserCubit>();
        final bool busy = state is DeleteUserLoading;

        return AppDialogShell(
          title: s.deleteUserTitle,
          icon: Icons.delete_outline_rounded,
          canClose: !busy,
          onClose: () => Navigator.of(context).pop(false),
          actions: <Widget>[
            AppButton(
              label: s.cancel,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.secondary,
              onPressed: busy ? null : () => Navigator.of(context).pop(false),
            ),
            AppButton(
              label: s.delete,
              loadingLabel: s.deletingUser,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.danger,
              isLoading: busy,
              onPressed: busy ? null : () => cubit.delete(user.id),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (state is DeleteUserFailure) ...<Widget>[
                AppAlert(
                  feedback: _failureFeedback(state.error, s),
                  onDismiss: cubit.dismissFailure,
                  dismissTooltip: s.dismiss,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                s.deleteUserPrompt(user.name),
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                s.deleteUserHint,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              ),
            ],
          ),
        );
      },
    );
  }

  AppFeedback _failureFeedback(AppError error, AppStrings s) {
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackDeleteUserTitle,
    );

    if (error.kind != AppErrorKind.notFound) return feedback;

    return AppFeedback(
      kind: feedback.kind,
      title: feedback.title,
      message: s.userGone,
    );
  }
}
