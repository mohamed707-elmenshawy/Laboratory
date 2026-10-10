import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../../laboratories/data/models/laboratory_menu_item.dart';
import '../../logic/users_cubit.dart';

class UsersToolbar extends StatelessWidget {
  const UsersToolbar({super.key, required this.laboratories});

  static const double _stackFrom = 720;
  static const double _searchMaxWidth = 340;
  static const double _filterWidth = 220;

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

          if (constraints.maxWidth < _stackFrom) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                search,
                const SizedBox(height: AppSpacing.md),
                laboratory,
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
              SizedBox(width: _filterWidth, child: laboratory),
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
    final UsersCubit cubit = context.read<UsersCubit>();
    final String search = context.select((UsersCubit cubit) => cubit.search);

    return AppSearchField(
      hint: s.searchUsersHint,
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
    final UsersCubit cubit = context.read<UsersCubit>();
    final int? selected = context.select(
      (UsersCubit cubit) => cubit.laboratoryId,
    );
    final bool enabled = context.select((UsersCubit cubit) => !cubit.isBusy);

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
