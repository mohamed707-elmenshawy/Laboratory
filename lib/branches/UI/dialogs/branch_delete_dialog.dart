import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/branch_model.dart';
import '../../logic/delete_branch_cubit.dart';

class BranchDeleteDialog extends StatelessWidget {
  const BranchDeleteDialog({super.key, required this.branch});

  final BranchModel branch;

  static Future<bool> show(BuildContext context, BranchModel branch) async {
    final bool? deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<DeleteBranchCubit>(
        create: (_) => getIt<DeleteBranchCubit>(),
        child: BranchDeleteDialog(branch: branch),
      ),
    );

    return deleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocConsumer<DeleteBranchCubit, DeleteBranchState>(
      listenWhen: (DeleteBranchState previous, DeleteBranchState next) =>
          next is DeleteBranchSuccess,
      listener: (BuildContext context, DeleteBranchState state) =>
          Navigator.of(context).pop(true),
      builder: (BuildContext context, DeleteBranchState state) {
        final DeleteBranchCubit cubit = context.read<DeleteBranchCubit>();
        final bool busy = state is DeleteBranchLoading;

        return AppDialogShell(
          title: s.deleteBranchTitle,
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
              loadingLabel: s.deletingBranch,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.danger,
              isLoading: busy,
              onPressed: busy ? null : () => cubit.delete(branch.id),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (state is DeleteBranchFailure) ...<Widget>[
                AppAlert(
                  feedback: _failureFeedback(state.error, s),
                  onDismiss: cubit.dismissFailure,
                  dismissTooltip: s.dismiss,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                s.deleteBranchPrompt(branch.name),
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                s.deleteBranchHint,
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
      title: s.feedbackDeleteBranchTitle,
    );

    if (error.kind != AppErrorKind.notFound) return feedback;

    return AppFeedback(
      kind: feedback.kind,
      title: feedback.title,
      message: s.branchGone,
    );
  }
}
