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
import '../data/models/sample_types_page.dart';
import '../data/models/sample_type_model.dart';
import '../logic/sample_types_cubit.dart';
import '../logic/sample_type_status_cubit.dart';
import 'dialogs/sample_type_delete_dialog.dart';
import 'sample_type_details_view.dart';
import 'sample_type_form_view.dart';
import 'widgets/sample_types_pagination_bar.dart';
import 'widgets/sample_types_states.dart';
import 'widgets/sample_types_table.dart';
import 'widgets/sample_types_toolbar.dart';

class SampleTypesView extends StatefulWidget {
  const SampleTypesView({super.key});

  static Widget page() => MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<SampleTypesCubit>(
        create: (_) => getIt<SampleTypesCubit>()..load(),
      ),
      BlocProvider<SampleTypeStatusCubit>(
        create: (_) => getIt<SampleTypeStatusCubit>(),
      ),
    ],
    child: const SampleTypesView(),
  );

  @override
  State<SampleTypesView> createState() => _SampleTypesViewState();
}

class _SampleTypesViewState extends State<SampleTypesView> {
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

  void _openEdit(SampleTypeModel sampleType) => setState(() {
    _editingId = sampleType.id;
    _detailsId = null;
    _creating = false;
    _notice = null;
  });

  void _onCreated() {
    setState(() {
      _creating = false;
      _notice = _Notice.created;
    });

    final SampleTypesCubit cubit = context.read<SampleTypesCubit>();
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
    context.read<SampleTypesCubit>().load();
  }

  void _openDetails(SampleTypeModel sampleType) => setState(() {
    _detailsId = sampleType.id;
    _notice = null;
  });

  void _closeDetails() => setState(() => _detailsId = null);

  void _onToggleStatus(SampleTypeModel sampleType) {
    setState(() {
      _notice = null;
      _statusError = null;
    });
    context.read<SampleTypeStatusCubit>().toggle(sampleType);
  }

  void _onStatusChanged(SampleTypeModel sampleType) {
    setState(() {
      _statusError = null;
      _notice = sampleType.isActive ? _Notice.activated : _Notice.deactivated;
    });
    context.read<SampleTypesCubit>().sampleTypeUpdated(sampleType);
  }

  Future<void> _onDelete(SampleTypeModel sampleType) async {
    final bool deleted = await SampleTypeDeleteDialog.show(context, sampleType);
    if (!deleted || !mounted) return;

    setState(() {
      _detailsId = null;
      _notice = _Notice.deleted;
    });
    context.read<SampleTypesCubit>().load();
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
      return SampleTypeFormView.page(
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_editingId case final int id) {
      return SampleTypeFormView.page(
        id: id,
        onCancel: _closeForm,
        onSaved: _onSaved,
        onCreated: _onCreated,
      );
    }

    if (_detailsId case final int id) {
      return SampleTypeDetailsView.page(
        id: id,
        onBack: _closeDetails,
        onEdit: _openEdit,
        onDelete: _onDelete,
      );
    }

    return BlocListener<SampleTypeStatusCubit, SampleTypeStatusState>(
      listenWhen:
          (SampleTypeStatusState previous, SampleTypeStatusState next) =>
              next is SampleTypeStatusSuccess ||
              next is SampleTypeStatusFailure,
      listener: (BuildContext context, SampleTypeStatusState state) =>
          switch (state) {
            SampleTypeStatusSuccess(:final SampleTypeModel sampleType) =>
              _onStatusChanged(sampleType),
            SampleTypeStatusFailure(:final AppError error) => setState(
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
                        s.sampleTypesTitle,
                        style: base
                            .merge(AppTextStyles.h2)
                            .copyWith(color: AppColors.ink),
                      ),
                      const SizedBox(height: AppSpacing.xs + 2),
                      Text(
                        s.sampleTypesSubtitle,
                        style: base
                            .merge(AppTextStyles.body)
                            .copyWith(color: AppColors.inkSubtle),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                AppButton(
                  label: s.newSampleType,
                  size: AppButtonSize.medium,
                  icon: Icons.add_rounded,
                  onPressed: _openCreate,
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: () => context.read<SampleTypesCubit>().load(),
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
                    title: s.sampleTypeCreatedTitle,
                    message: s.sampleTypeCreatedMessage,
                  ),
                  _Notice.saved => AppFeedback.success(
                    title: s.sampleTypeSavedTitle,
                    message: s.sampleTypeSavedMessage,
                  ),
                  _Notice.deleted => AppFeedback.success(
                    title: s.sampleTypeDeletedTitle,
                    message: s.sampleTypeDeletedMessage,
                  ),
                  _Notice.activated => AppFeedback.success(
                    title: s.sampleTypeActivatedTitle,
                    message: s.sampleTypeActivatedMessage,
                  ),
                  _Notice.deactivated => AppFeedback.success(
                    title: s.sampleTypeDeactivatedTitle,
                    message: s.sampleTypeDeactivatedMessage,
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
                  title: s.feedbackSampleTypeStatusTitle,
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
  final ValueChanged<SampleTypeModel> onView;
  final ValueChanged<SampleTypeModel> onEdit;
  final ValueChanged<SampleTypeModel> onDelete;
  final ValueChanged<SampleTypeModel> onToggleStatus;

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
          SampleTypesToolbar(laboratories: laboratories),
          BlocBuilder<SampleTypesCubit, SampleTypesState>(
            builder: (BuildContext context, SampleTypesState state) =>
                switch (state) {
                  SampleTypesLoaded(:final SampleTypesPage page) => _Loaded(
                    page: page,
                    onView: onView,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onToggleStatus: onToggleStatus,
                  ),
                  SampleTypesFailure(:final AppError error) =>
                    SampleTypesFailureState(error: error),
                  SampleTypesInitial() ||
                  SampleTypesLoading() => const SampleTypesLoadingState(),
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

  final SampleTypesPage page;
  final ValueChanged<SampleTypeModel> onView;
  final ValueChanged<SampleTypeModel> onEdit;
  final ValueChanged<SampleTypeModel> onDelete;
  final ValueChanged<SampleTypeModel> onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (page.items.isEmpty)
          SampleTypesEmptyState(
            filtered: context.read<SampleTypesCubit>().hasFilters,
          )
        else
          SampleTypesTable(
            sampleTypes: page.items,
            onView: onView,
            onEdit: onEdit,
            onDelete: onDelete,
            onToggleStatus: onToggleStatus,
            statusBusyId: context.select(
              (SampleTypeStatusCubit cubit) => switch (cubit.state) {
                SampleTypeStatusLoading(:final int id) => id,
                _ => null,
              },
            ),
          ),
        SampleTypesPaginationBar(pagination: page.pagination),
      ],
    );
  }
}
