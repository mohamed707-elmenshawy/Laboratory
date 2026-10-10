import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/models/named_ref.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/parameter_model.dart';
import '../logic/parameter_details_cubit.dart';
import 'widgets/parameter_page_header.dart';

class ParameterDetailsView extends StatelessWidget {
  const ParameterDetailsView({
    super.key,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  static Widget page({
    required int id,
    required VoidCallback onBack,
    required ValueChanged<ParameterModel> onEdit,
    required ValueChanged<ParameterModel> onDelete,
  }) => BlocProvider<ParameterDetailsCubit>(
    create: (_) => getIt<ParameterDetailsCubit>()..load(id),
    child: ParameterDetailsView(
      onBack: onBack,
      onEdit: onEdit,
      onDelete: onDelete,
    ),
  );

  final VoidCallback onBack;
  final ValueChanged<ParameterModel> onEdit;
  final ValueChanged<ParameterModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: BlocBuilder<ParameterDetailsCubit, ParameterDetailsState>(
        builder: (BuildContext context, ParameterDetailsState state) {
          final ParameterModel? parameter = switch (state) {
            ParameterDetailsLoaded(:final ParameterModel parameter) =>
              parameter,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ParameterPageHeader(
                title: parameter?.name ?? s.parameterDetailsTitle,
                subtitle: s.parameterDetailsSubtitle,
                onBack: onBack,
                trailing: parameter == null
                    ? null
                    : AppPill(
                        label: parameter.isActive
                            ? s.statusActive
                            : s.statusInactive,
                        tone: parameter.isActive
                            ? AppPillTone.success
                            : AppPillTone.neutral,
                        icon: parameter.isActive
                            ? Icons.check_circle_rounded
                            : Icons.pause_circle_outline_rounded,
                      ),
              ),
              const SizedBox(height: AppSpacing.x3l),
              switch (state) {
                ParameterDetailsLoaded(:final ParameterModel parameter) =>
                  _Loaded(
                    parameter: parameter,
                    onEdit: () => onEdit(parameter),
                    onDelete: () => onDelete(parameter),
                  ),
                ParameterDetailsFailure(:final AppError error) => _Failed(
                  error: error,
                ),
                ParameterDetailsInitial() ||
                ParameterDetailsLoading() => const _Loading(),
              },
            ],
          );
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.parameter,
    required this.onEdit,
    required this.onDelete,
  });

  final ParameterModel parameter;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Row(
            label: s.parameterDescriptionLabel,
            child: _Value(
              parameter.description?.trim().isNotEmpty == true
                  ? parameter.description!
                  : s.noDescription,
              muted: parameter.description?.trim().isNotEmpty != true,
            ),
          ),
          _Row(
            label: s.branchLaboratoryLabel,
            child: _RefValue(value: parameter.laboratory),
          ),
          _Row(
            label: s.branchNameLabel,
            child: _RefValue(value: parameter.branch),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1, thickness: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AppButton(
                label: s.edit,
                icon: Icons.edit_outlined,
                size: AppButtonSize.medium,
                variant: AppButtonVariant.secondary,
                onPressed: onEdit,
              ),
              const SizedBox(width: AppSpacing.md),
              AppButton(
                label: s.delete,
                icon: Icons.delete_outline_rounded,
                size: AppButtonSize.medium,
                variant: AppButtonVariant.danger,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RefValue extends StatelessWidget {
  const _RefValue({required this.value});

  final NamedRef? value;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool has = value != null && value!.name.trim().isNotEmpty;

    return _Value(has ? value!.name : s.notAssigned, muted: !has);
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: base
                  .merge(AppTextStyles.caption)
                  .copyWith(fontSize: 12.5, color: AppColors.inkSubtle),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.value, {this.muted = false});

  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      value,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(
            fontWeight: muted ? FontWeight.w400 : FontWeight.w500,
            color: muted ? AppColors.inkFaint : AppColors.ink,
          ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error});

  final AppError error;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final AppFeedback feedback = error.toFeedback(
      s,
      title: s.feedbackParameterDetailsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.parameterGone
            : feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<ParameterDetailsCubit>().reload(),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppSpacing.x5l),
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
