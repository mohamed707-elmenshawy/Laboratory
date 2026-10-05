import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/localization/localization.dart';
import '../../core/models/named_ref.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/unit_model.dart';
import '../logic/unit_details_cubit.dart';
import 'widgets/unit_page_header.dart';

class UnitDetailsView extends StatelessWidget {
  const UnitDetailsView({
    super.key,
    required this.onBack,
    required this.onEdit,
    required this.onDelete,
  });

  static Widget page({
    required int id,
    required VoidCallback onBack,
    required ValueChanged<UnitModel> onEdit,
    required ValueChanged<UnitModel> onDelete,
  }) => BlocProvider<UnitDetailsCubit>(
    create: (_) => getIt<UnitDetailsCubit>()..load(id),
    child: UnitDetailsView(onBack: onBack, onEdit: onEdit, onDelete: onDelete),
  );

  final VoidCallback onBack;
  final ValueChanged<UnitModel> onEdit;
  final ValueChanged<UnitModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return HomePageFrame(
      maxWidth: AppSizes.pageFormMaxWidth,
      child: BlocBuilder<UnitDetailsCubit, UnitDetailsState>(
        builder: (BuildContext context, UnitDetailsState state) {
          final UnitModel? unit = switch (state) {
            UnitDetailsLoaded(:final UnitModel unit) => unit,
            _ => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UnitPageHeader(
                title: unit?.name ?? s.unitDetailsTitle,
                subtitle: s.unitDetailsSubtitle,
                onBack: onBack,
                trailing: unit == null
                    ? null
                    : AppPill(
                        label: unit.isActive
                            ? s.statusActive
                            : s.statusInactive,
                        tone: unit.isActive
                            ? AppPillTone.success
                            : AppPillTone.neutral,
                        icon: unit.isActive
                            ? Icons.check_circle_rounded
                            : Icons.pause_circle_outline_rounded,
                      ),
              ),
              const SizedBox(height: AppSpacing.x3l),
              switch (state) {
                UnitDetailsLoaded(:final UnitModel unit) => _Loaded(
                  unit: unit,
                  onEdit: () => onEdit(unit),
                  onDelete: () => onDelete(unit),
                ),
                UnitDetailsFailure(:final AppError error) => _Failed(
                  error: error,
                ),
                UnitDetailsInitial() ||
                UnitDetailsLoading() => const _Loading(),
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
    required this.unit,
    required this.onEdit,
    required this.onDelete,
  });

  final UnitModel unit;
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
            label: s.unitSymbolLabel,
            child: _Value(
              unit.symbol.trim().isNotEmpty ? unit.symbol : s.notAssigned,
              muted: unit.symbol.trim().isEmpty,
            ),
          ),
          _Row(
            label: s.unitDescriptionLabel,
            child: _Value(
              unit.description?.trim().isNotEmpty == true
                  ? unit.description!
                  : s.noDescription,
              muted: unit.description?.trim().isNotEmpty != true,
            ),
          ),
          _Row(
            label: s.branchLaboratoryLabel,
            child: _RefValue(value: unit.laboratory),
          ),
          _Row(
            label: s.branchNameLabel,
            child: _RefValue(value: unit.branch),
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
      title: s.feedbackUnitDetailsTitle,
    );

    return AppAlert(
      feedback: AppFeedback(
        kind: feedback.kind,
        title: feedback.title,
        message: error.kind == AppErrorKind.notFound
            ? s.unitGone
            : feedback.message,
        actionLabel: s.retry,
        onAction: () => context.read<UnitDetailsCubit>().reload(),
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
