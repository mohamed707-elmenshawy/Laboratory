import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/error/app_error.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../logic/laboratories_cubit.dart';

class LaboratoriesLoadingState extends StatelessWidget {
  const LaboratoriesLoadingState({super.key});

  static const double _rows = 4;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.x6l * _rows,
      child: const Center(
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

class LaboratoriesEmptyState extends StatelessWidget {
  const LaboratoriesEmptyState({super.key});

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
            child: const Icon(
              Icons.biotech_outlined,
              size: AppSizes.iconLg,
              color: AppColors.inkSubtle,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            s.laboratoriesEmptyTitle,
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
            s.laboratoriesEmptyMessage,
            textAlign: TextAlign.center,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(color: AppColors.inkSubtle),
          ),
        ],
      ),
    );
  }
}

class LaboratoriesFailureState extends StatelessWidget {
  const LaboratoriesFailureState({super.key, required this.error});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackLaboratoriesTitle,
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: AppAlert(
        feedback: AppFeedback(
          kind: feedback.kind,
          title: feedback.title,
          message: feedback.message,
          actionLabel: s.retry,
          onAction: () => context.read<LaboratoriesCubit>().retry(),
        ),
      ),
    );
  }
}
