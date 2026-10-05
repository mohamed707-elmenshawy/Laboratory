import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../laboratories/data/models/laboratory_menu_item.dart';
import '../../data/models/units_query.dart';
import '../../logic/units_cubit.dart';

class UnitsToolbar extends StatelessWidget {
  const UnitsToolbar({super.key, required this.laboratories});

  static const double _stackFrom = 860;
  static const double _searchMaxWidth = 340;
  static const double _laboratoryWidth = 220;

  final List<LaboratoryMenuItem> laboratories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.line,
            width: AppSizes.borderWidth,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Widget search = _SearchField();
          final Widget laboratory = _LaboratoryFilter(
            laboratories: laboratories,
          );
          const Widget status = _StatusFilter();

          if (constraints.maxWidth < _stackFrom) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                search,
                const SizedBox(height: AppSpacing.md),
                laboratory,
                const SizedBox(height: AppSpacing.md),
                const _StatusFilter(expand: true),
              ],
            );
          }

          return Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _searchMaxWidth,
                    ),
                    child: search,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              SizedBox(width: _laboratoryWidth, child: laboratory),
              const SizedBox(width: AppSpacing.md),
              status,
            ],
          );
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UnitsCubit cubit = context.read<UnitsCubit>();
    final String search = context.select((UnitsCubit cubit) => cubit.search);

    return AppSearchField(
      hint: s.searchUnitsHint,
      initialValue: cubit.search,
      externalValue: search,
      onSubmitted: cubit.changeSearch,
    );
  }
}

class _LaboratoryFilter extends StatelessWidget {
  const _LaboratoryFilter({required this.laboratories});

  final List<LaboratoryMenuItem> laboratories;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UnitsCubit cubit = context.read<UnitsCubit>();
    final int? selected = context.select(
      (UnitsCubit cubit) => cubit.laboratoryId,
    );
    final bool enabled = context.select((UnitsCubit cubit) => !cubit.isBusy);

    return AppSelect<int>(
      label: s.branchLaboratoryLabel,
      hideLabel: true,
      height: AppSizes.controlMedium,
      value: selected ?? 0,
      enabled: enabled && laboratories.isNotEmpty,
      options: <AppSelectOption<int>>[
        AppSelectOption<int>(value: 0, label: s.allLaboratories),
        for (final LaboratoryMenuItem item in laboratories)
          AppSelectOption<int>(value: item.id, label: item.name),
      ],
      onChanged: (int value) =>
          cubit.changeLaboratory(value == 0 ? null : value),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({this.expand = false});

  final bool expand;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final UnitsCubit cubit = context.read<UnitsCubit>();
    final UnitStatusFilter selected = context.select(
      (UnitsCubit cubit) => cubit.status,
    );

    return AppSegmentedFilter<UnitStatusFilter>(
      semanticLabel: s.statusFilterLabel,
      expand: expand,
      value: selected,
      onChanged: cubit.changeStatus,
      segments: <AppSegment<UnitStatusFilter>>[
        AppSegment<UnitStatusFilter>(
          value: UnitStatusFilter.all,
          label: s.statusFilterAll,
        ),
        AppSegment<UnitStatusFilter>(
          value: UnitStatusFilter.active,
          label: s.statusActive,
          dotColor: AppColors.success,
        ),
        AppSegment<UnitStatusFilter>(
          value: UnitStatusFilter.inactive,
          label: s.statusInactive,
          dotColor: AppColors.inkFaint,
        ),
      ],
    );
  }
}
