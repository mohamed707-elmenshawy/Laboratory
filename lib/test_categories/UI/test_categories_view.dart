import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design_system/design_system.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/localization/localization.dart';
import '../../core/ui/ui.dart';
import '../../home/UI/widgets/home_page_frame.dart';
import '../../laboratories/data/models/laboratory_menu_item.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../data/models/test_categories_page.dart';
import '../data/models/test_category_model.dart';
import '../logic/test_categories_cubit.dart';
import '../logic/test_category_status_cubit.dart';
import 'dialogs/test_category_delete_dialog.dart';
import 'test_category_details_view.dart';
import 'test_category_form_view.dart';
import 'widgets/test_categories_pagination_bar.dart';
import 'widgets/test_categories_states.dart';
import 'widgets/test_categories_table.dart';
import 'widgets/test_categories_toolbar.dart';

class TestCategoriesView extends StatefulWidget {
  const TestCategoriesView({super.key});

  static Widget page() => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<TestCategoriesCubit>(
        create: (_) => getIt<TestCategoriesCubit>()..load(),
      ),
      BlocProvider<TestCategoryStatusCubit>(
        create: (_) => getIt<TestCategoryStatusCubit>(),
      ),
    ],
    child: const TestCategoriesView(),
  );

  @override
  State<TestCategoriesView> createState() => _TestCategoriesViewState();
}

class _TestCategoriesViewState extends State<TestCategoriesView> {
  List<LaboratoryMenuItem> _laboratories = const <LaboratoryMenuItem>[];
  int? _detailsId;
  int? _editingId;
  bool _creating = false;
  _Notice? _notice;
  AppError? _statusError;

  void _openCreate() => setState(() {
    _creating = true;
    _detailsId = null;
    _editingId = null;
    _notice = null;
  });

  void _closeForm() => setState(() {
    _creating = false;
    _editingId = null;
  });

  void _openEdit(TestCategoryModel category) => setState(() {
    _editingId = category.id;
    _detailsId = null;
    _creating = false;
    _notice = null;
  });

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final TestCategoriesCubit cubit = context.read<TestCategoriesCubit>();
    if (cubit.page == 1) {
      cubit.load();
    } else {
      cubit.goToPage(1);
    }
  }

  void _onSaved() {
    setState(() {
      _editingId = null;
      _notice = _Notice.saved;
    });
    context.read<TestCategoriesCubit>().load();
  }

  void _openDetails(TestCategoryModel category) => setState(() {
    _detailsId = category.id;
    _notice = null;
  });

  void _closeDetails() => setState(() => _detailsId = null);

  void _onToggleStatus(TestCategoryModel category) {
    setState(() {
      _notice = null;
      _statusError = null;
    });
    context.read<TestCategoryStatusCubit>().toggle(category);
  }

  void _onStatusChanged(TestCategoryModel category) {
    setState(() {
      _statusError = null;
      _notice = category.isActive ? _Notice.activated : _Notice.deactivated;
    });
    context.read<TestCategoriesCubit>().testCategoryUpdated(category);
  }

  Future<void> _onDelete(TestCategoryModel category) async {
    final bool deleted = await TestCategoryDeleteDialog.show(context, category);
    if (!deleted || !mounted) return;

    setState(() {
      _detailsId = null;
      _notice = _Notice.deleted;
    });
    context.read<TestCategoriesCubit>().load();
  }

  @override
  void initState() {
    super.initState();
    _loadLaboratories();
  }

  Future<void> _loadLaboratories() async {
    final Result<List<LaboratoryMenuItem>> result =
        await getIt<LaboratoriesRepo>().fetchLaboratoriesMenu();

    if (!mounted) return;
    if (result case Success<List<LaboratoryMenuItem>>(
      :final List<LaboratoryMenuItem> data,
    )) {
      setState(() => _laboratories = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (_creating) {
      return TestCategoryFormView.page(
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_editingId case final int id) {
      return TestCategoryFormView.page(
        id: id,
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_detailsId case final int id) {
      return TestCategoryDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onEdit: _openEdit,
        onDelete: _onDelete,
      );
    }

    return BlocListener<TestCategoryStatusCubit, TestCategoryStatusState>(
      listenWhen:
          (TestCategoryStatusState previous, TestCategoryStatusState next) =>
              next is TestCategoryStatusSuccess ||
              next is TestCategoryStatusFailure,
      listener: (BuildContext context, TestCategoryStatusState state) =>
          switch (state) {
            TestCategoryStatusSuccess(:final TestCategoryModel category) =>
              _onStatusChanged(category),
            TestCategoryStatusFailure(:final AppError error) => setState(
              () => _statusError = error,
            ),
            _ => null,
          },
      child: HomePageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        s.testCategoriesTitle,
                        style: base
                            .merge(AppTextStyles.h2)
                            .copyWith(color: AppColors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xs + 2),
                      Text(
                        s.testCategoriesSubtitle,
                        style: base
                            .merge(AppTextStyles.body)
                            .copyWith(color: AppColors.inkSubtle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                AppButton(
                  label: s.newTestCategory,
                  size: AppButtonSize.medium,
                  icon: Icons.add_rounded,
                  onPressed: _openCreate,
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () => context.read<TestCategoriesCubit>().load(),
                  tooltip: s.refresh,
                  iconSize: AppSizes.iconMd,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: AppSizes.hitTarget,
                    height: AppSizes.hitTarget,
                  ),
                  hoverColor: AppColors.brandWash,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
            if (_notice case final _Notice notice) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              AppAlert(
                feedback: switch (notice) {
                  _Notice.created => AppFeedback.success(
                    title: s.testCategoryCreatedTitle,
                    message: s.testCategoryCreatedMessage,
                  ),
                  _Notice.saved => AppFeedback.success(
                    title: s.testCategorySavedTitle,
                    message: s.testCategorySavedMessage,
                  ),
                  _Notice.deleted => AppFeedback.success(
                    title: s.testCategoryDeletedTitle,
                    message: s.testCategoryDeletedMessage,
                  ),
                  _Notice.activated => AppFeedback.success(
                    title: s.testCategoryActivatedTitle,
                    message: s.testCategoryActivatedMessage,
                  ),
                  _Notice.deactivated => AppFeedback.success(
                    title: s.testCategoryDeactivatedTitle,
                    message: s.testCategoryDeactivatedMessage,
                  ),
                },
                onDismiss: () => setState(() => _notice = null),
                dismissTooltip: s.dismiss,
              ),
            ],
            if (_statusError case final AppError error) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              AppAlert(
                feedback: error.toFeedback(
                  s,
                  title: s.feedbackTestCategoryStatusTitle,
                ),
                onDismiss: () => setState(() => _statusError = null),
                dismissTooltip: s.dismiss,
              ),
            ],
            const SizedBox(height: AppSpacing.x3l),
            _ListCard(
              laboratories: _laboratories,
              onView: _openDetails,
              onEdit: _openEdit,
              onDelete: _onDelete,
              onToggleStatus: _onToggleStatus,
            ),
          ],
        ),
      ),
    );
  }
}

enum _Notice { created, saved, deleted, activated, deactivated }

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.laboratories,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final List<LaboratoryMenuItem> laboratories;
  final ValueChanged<TestCategoryModel> onView;
  final ValueChanged<TestCategoryModel> onEdit;
  final ValueChanged<TestCategoryModel> onDelete;
  final ValueChanged<TestCategoryModel> onToggleStatus;

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
          TestCategoriesToolbar(laboratories: laboratories),
          BlocBuilder<TestCategoriesCubit, TestCategoriesState>(
            builder: (BuildContext context, TestCategoriesState state) =>
                switch (state) {
                  TestCategoriesLoaded(:final TestCategoriesPage page) =>
                    _Loaded(
                      page: page,
                      onView: onView,
                      onEdit: onEdit,
                      onDelete: onDelete,
                      onToggleStatus: onToggleStatus,
                    ),
                  TestCategoriesFailure(:final AppError error) =>
                    TestCategoriesFailureState(error: error),
                  TestCategoriesInitial() ||
                  TestCategoriesLoading() => const TestCategoriesLoadingState(),
                },
          ),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.page,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final TestCategoriesPage page;
  final ValueChanged<TestCategoryModel> onView;
  final ValueChanged<TestCategoryModel> onEdit;
  final ValueChanged<TestCategoryModel> onDelete;
  final ValueChanged<TestCategoryModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          TestCategoriesEmptyState(
            filtered: context.read<TestCategoriesCubit>().hasFilters,
          )
        else
          TestCategoriesTable(
            categories: page.items,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
            onToggleStatus: onToggleStatus,
            statusBusyId: context.select(
              (TestCategoryStatusCubit cubit) => switch (cubit.state) {
                TestCategoryStatusLoading(:final int id) => id,
                _ => null,
              },
            ),
          ),
        TestCategoriesPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
