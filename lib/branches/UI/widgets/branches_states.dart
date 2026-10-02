import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/branches_cubit.dart';

class BranchesLoadingState extends StatelessWidget {
  const BranchesLoadingState({super.key});

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

class BranchesEmptyState extends StatelessWidget {
  const BranchesEmptyState({super.key, this.filtered = false});

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
              filtered
                  ? Icons.search_off_rounded
                  : Icons.store_mall_directory_outlined,
              size: AppSizes.iconLg,
              color: AppColors.inkSubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            filtered ? s.branchesNoMatchTitle : s.branchesEmptyTitle,
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
            filtered ? s.branchesNoMatchMessage : s.branchesEmptyMessage,
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
              onPressed: () => context.read<BranchesCubit>().clearFilters(),
            ),
          ],
        ],
      ),
    );
  }
}

class BranchesFailureState extends StatelessWidget {
  const BranchesFailureState({super.key, required this.error});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackBranchesTitle,
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: AppAlert(
        feedback: AppFeedback(
          kind: feedback.kind,
          title: feedback.title,
          message: feedback.message,
          actionLabel: s.retry,
          onAction: () => context.read<BranchesCubit>().retry(),
        ),
      ),
    );
  }
}
