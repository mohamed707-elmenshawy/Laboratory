import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/test_category_model.dart';
import '../../logic/delete_test_category_cubit.dart';

class TestCategoryDeleteDialog extends StatelessWidget {
  const TestCategoryDeleteDialog({super.key, required this.category});

  final TestCategoryModel category;

  static Future<bool> show(
    BuildContext context,
    TestCategoryModel category,
  ) async {
    final bool? deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider<DeleteTestCategoryCubit>(
        create: (_) => getIt<DeleteTestCategoryCubit>(),
        child: TestCategoryDeleteDialog(category: category),
      ),
    );

    return deleted ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return BlocConsumer<DeleteTestCategoryCubit, DeleteTestCategoryState>(
      listenWhen:
          (DeleteTestCategoryState previous, DeleteTestCategoryState next) =>
              next is DeleteTestCategorySuccess,
      listener: (BuildContext context, DeleteTestCategoryState state) =>
          Navigator.of(context).pop(true),
      builder: (BuildContext context, DeleteTestCategoryState state) {
        final DeleteTestCategoryCubit cubit = context
            .read<DeleteTestCategoryCubit>();
        final bool busy = state is DeleteTestCategoryLoading;

        return AppDialogShell(
          title: s.deleteTestCategoryTitle,
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
              loadingLabel: s.deletingTestCategory,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.danger,
              isLoading: busy,
              onPressed: busy ? null : () => cubit.delete(category.id),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (state is DeleteTestCategoryFailure) ...<Widget>[
                AppAlert(
                  feedback: _failureFeedback(state.error, s),
                  onDismiss: cubit.dismissFailure,
                  dismissTooltip: s.dismiss,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(
                s.deleteTestCategoryPrompt(category.name),
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                s.deleteTestCategoryHint,
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
      title: s.feedbackDeleteTestCategoryTitle,
    );

    if (error.kind != AppErrorKind.notFound) return feedback;

    return AppFeedback(
      kind: feedback.kind,
      title: feedback.title,
      message: s.testCategoryGone,
    );
  }
}
