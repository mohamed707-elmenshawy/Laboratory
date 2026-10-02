import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../data/models/term_model.dart';
import '../logic/terms_cubit.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    builder: (_) => BlocProvider<TermsCubit>(
      create: (_) => getIt<TermsCubit>()..load(),
      child: const TermsDialog(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppDialogShell(
      title: s.termsTitle,
      icon: Icons.gavel_rounded,
      actions: <Widget>[
        AppButton(
          label: s.close,
          size: AppButtonSize.medium,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      child: BlocBuilder<TermsCubit, TermsState>(
        builder: (BuildContext context, TermsState state) => switch (state) {
          TermsInitial() || TermsLoading() => const _TermsLoading(),
          TermsFailure(:final AppError error) => _TermsFailure(error: error),
          TermsLoaded(:final List<TermModel> terms) when terms.isEmpty =>
            const _TermsEmpty(),
          TermsLoaded(:final List<TermModel> terms) => _TermsList(terms: terms),
        },
      ),
    );
  }
}

class _TermsLoading extends StatelessWidget {
  const _TermsLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppSpacing.x6l * 2,
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

class _TermsFailure extends StatelessWidget {
  const _TermsFailure({required this.error});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackTermsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<TermsCubit>().load(),
      ),
    );
  }
}

class _TermsEmpty extends StatelessWidget {
  const _TermsEmpty();

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      context.strings.termsEmpty,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(color: AppColors.inkSubtle),
    );
  }
}

class _TermsList extends StatelessWidget {
  const _TermsList({required this.terms});

  final List<TermModel> terms;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < terms.length; i++) ...<Widget>[
          if (i > 0) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1, thickness: 1, color: AppColors.line),
            const SizedBox(height: AppSpacing.lg),
          ],
          Text(
            terms[i].name,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Text(
            terms[i].description,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(color: AppColors.inkMuted),
          ),
        ],
      ],
    );
  }
}
