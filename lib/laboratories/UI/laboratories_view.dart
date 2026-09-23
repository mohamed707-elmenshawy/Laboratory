import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../data/models/laboratories_page.dart';
import '../data/models/laboratory_model.dart';
import '../logic/laboratories_cubit.dart';
import 'dialogs/laboratory_delete_dialog.dart';
import 'dialogs/laboratory_details_dialog.dart';
import 'dialogs/laboratory_form_dialog.dart';
import 'widgets/laboratories_header.dart';
import 'widgets/laboratories_pagination_bar.dart';
import 'widgets/laboratories_states.dart';
import 'widgets/laboratories_table.dart';
import 'widgets/laboratories_toolbar.dart';

class LaboratoriesView extends StatelessWidget {
  const LaboratoriesView({super.key});

  static Widget page() => BlocProvider<LaboratoriesCubit>(
    create: (_) => getIt<LaboratoriesCubit>()..load(),
    child: const LaboratoriesView(),
  );

  @override
  Widget build(BuildContext context) {
    return HomePageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LaboratoriesHeader(
            onCreate: () => LaboratoryFormDialog.show(context),
            onRefresh: () => context.read<LaboratoriesCubit>().load(),
          ),
          const SizedBox(height: AppSpacing.x3l),
          const _ListCard(),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.line, width: AppSizes.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const LaboratoriesToolbar(),
          BlocBuilder<LaboratoriesCubit, LaboratoriesState>(
            builder: (BuildContext context, LaboratoriesState state) =>
                switch (state) {
                  LaboratoriesLoaded(:final LaboratoriesPage page) => _Loaded(
                    page: page,
                  ),
                  LaboratoriesFailure(:final AppError error) =>
                    LaboratoriesFailureState(error: error),
                  LaboratoriesInitial() ||
                  LaboratoriesLoading() => const LaboratoriesLoadingState(),
                },
          ),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.page});

  final LaboratoriesPage page;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          LaboratoriesEmptyState(
            filtered: context.read<LaboratoriesCubit>().hasFilters,
          )
        else
          LaboratoriesTable(
            laboratories: page.items,
            onView: (LaboratoryModel laboratory) =>
                LaboratoryDetailsDialog.show(context, laboratory),
            onEdit: (LaboratoryModel laboratory) =>
                LaboratoryFormDialog.show(context, laboratory: laboratory),
            onDelete: (LaboratoryModel laboratory) =>
                LaboratoryDeleteDialog.show(context, laboratory),
          ),
        LaboratoriesPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
