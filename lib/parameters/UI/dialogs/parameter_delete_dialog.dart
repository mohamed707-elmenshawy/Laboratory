import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/parameter_model.dart';
import '../../logic/delete_parameter_cubit.dart';

class ParameterDeleteDialog extends StatelessWidget {
  const ParameterDeleteDialog({super.key, required this.parameter});

  final ParameterModel parameter;

  static Future<bool> show(
    BuildContext context,
    ParameterModel parameter,
  ) async {
    final bool? deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<DeleteParameterCubit>(
        create: (_) => getIt<DeleteParameterCubit>(),
        child: ParameterDeleteDialog(parameter: parameter),
      ),
    );

    return deleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocConsumer<DeleteParameterCubit, DeleteParameterState>(
      listenWhen: (DeleteParameterState previous, DeleteParameterState next) =>
          next is DeleteParameterSuccess,
      listener: (BuildContext context, DeleteParameterState state) =>
          Navigator.of(context).pop(true),
      builder: (BuildContext context, DeleteParameterState state) {
        final DeleteParameterCubit cubit = context.read<DeleteParameterCubit>();
        final bool busy = state is DeleteParameterLoading;

        return AppDialogShell(
          title: s.deleteParameterTitle,
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
              loadingLabel: s.deletingParameter,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.danger,
              isLoading: busy,
              onPressed: busy ? null : () => cubit.delete(parameter.id),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (state is DeleteParameterFailure) ...<Widget>[
                AppAlert(
                  feedback: _failureFeedback(state.error, s),
                  onDismiss: cubit.dismissFailure,
                  dismissTooltip: s.dismiss,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                s.deleteParameterPrompt(parameter.name),
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                s.deleteParameterHint,
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
      title: s.feedbackDeleteParameterTitle,
    );

    if (error.kind != AppErrorKind.notFound) return feedback;

    return AppFeedback(
      kind: feedback.kind,
      title: feedback.title,
      message: s.parameterGone,
    );
  }
}
