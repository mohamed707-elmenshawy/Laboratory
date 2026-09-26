import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/laboratory_model.dart';
import '../../logic/delete_laboratory_cubit.dart';
import 'laboratory_dialog_shell.dart';

class LaboratoryDeleteDialog extends StatelessWidget {
  const LaboratoryDeleteDialog({super.key, required this.laboratory});

  final LaboratoryModel laboratory;

  static Future<bool> show(
    BuildContext context,
    LaboratoryModel laboratory,
  ) async {
    final bool? deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<DeleteLaboratoryCubit>(
        create: (_) => getIt<DeleteLaboratoryCubit>(),
        child: LaboratoryDeleteDialog(laboratory: laboratory),
      ),
    );

    return deleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocConsumer<DeleteLaboratoryCubit, DeleteLaboratoryState>(
      listenWhen:
          (DeleteLaboratoryState previous, DeleteLaboratoryState next) =>
              next is DeleteLaboratorySuccess,
      listener: (BuildContext context, DeleteLaboratoryState state) =>
          Navigator.of(context).pop(true),
      builder: (BuildContext context, DeleteLaboratoryState state) {
        final DeleteLaboratoryCubit cubit = context
            .read<DeleteLaboratoryCubit>();
        final bool busy = state is DeleteLaboratoryLoading;

        return LaboratoryDialogShell(
          title: s.deleteLaboratoryTitle,
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
              loadingLabel: s.deletingLaboratory,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.danger,
              isLoading: busy,
              onPressed: busy ? null : () => cubit.delete(laboratory.id),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (state is DeleteLaboratoryFailure) ...<Widget>[
                AppAlert(
                  feedback: _failureFeedback(state.error, s),
                  onDismiss: cubit.dismissFailure,
                  dismissTooltip: s.dismiss,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                s.deleteLaboratoryPrompt(laboratory.name),
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                s.deleteLaboratoryHint,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              ),
              if (laboratory.branchesCount > 0) ...<Widget>[
                const SizedBox(height: AppSpacing.lg),
                AppAlert(
                  feedback: AppFeedback.warning(
                    title: s.deleteLaboratoryBranchesTitle,
                    message: s.deleteLaboratoryBranchesMessage(
                      laboratory.branchesCount,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  AppFeedback _failureFeedback(AppError error, AppStrings s) {
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackDeleteLaboratoryTitle,
    );

    if (error.kind != AppErrorKind.notFound) return feedback;

    return AppFeedback(
      kind: feedback.kind,
      title: feedback.title,
      message: s.laboratoryGone,
    );
  }
}
