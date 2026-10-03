import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/test_categories_cubit.dart';

class TestCategoriesLoadingState extends StatelessWidget {
  const TestCategoriesLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.x6l * 4,
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.brand600,
          ),
        ),
      ),
    );
  }
}

class TestCategoriesEmptyState extends StatelessWidget {
  const TestCategoriesEmptyState({super.key, this.filtered = false});

  final bool filtered;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.x5l,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: AppSizes.controlLarge,
            height: AppSizes.controlLarge,
            decoration: const BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: AppRadius.lgAll,
            ),
            child: Icon(
              filtered ? Icons.search_off_rounded : Icons.science_outlined,
              size: AppSizes.iconLg,
              color: AppColors.inkSubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            filtered
                ? s.testCategoriesNoMatchTitle
                : s.testCategoriesEmptyTitle,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            filtered
                ? s.testCategoriesNoMatchMessage
                : s.testCategoriesEmptyMessage,
            textAlign: TextAlign.center,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(color: AppColors.inkSubtle),
          ),
          if (filtered) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: s.clearFilters,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              icon: Icons.filter_alt_off_outlined,
              onPressed: () =>
                  context.read<TestCategoriesCubit>().clearFilters(),
            ),
          ],
        ],
      ),
    );
  }
}

class TestCategoriesFailureState extends StatelessWidget {
  const TestCategoriesFailureState({super.key, required this.error});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackTestCategoriesTitle,
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: AppAlert(
        feedback: AppFeedback(
          kind: feedback.kind,
          title: feedback.title,
          message: feedback.message,
          actionLabel: s.retry,
          onAction: () => context.read<TestCategoriesCubit>().retry(),
        ),
      ),
    );
  }
}
