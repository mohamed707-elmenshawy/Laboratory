import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../data/models/laboratory_model.dart';
import 'laboratory_row_actions.dart';
import 'laboratory_status_pill.dart';

typedef LaboratoryCallback = void Function(LaboratoryModel laboratory);

class LaboratoriesTable extends StatelessWidget {
  const LaboratoriesTable({
    super.key,
    required this.laboratories,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  static const double _stackFrom = 880;
  static const double actionsWidth = 176;

  final List<LaboratoryModel> laboratories;
  final LaboratoryCallback onView;
  final LaboratoryCallback onEdit;
  final LaboratoryCallback onDelete;
  final LaboratoryCallback onToggleStatus;
  final int? statusBusyId;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < _stackFrom;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!stacked) const _HeaderRow(),
            for (int i = 0; i < laboratories.length; i++) ...<Widget>[
              if (i > 0 || !stacked)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              if (stacked)
                _StackedRow(
                  laboratory: laboratories[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onToggleStatus: onToggleStatus,
                  statusBusyId: statusBusyId,
                )
              else
                _TableRow(
                  laboratory: laboratories[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onToggleStatus: onToggleStatus,
                  statusBusyId: statusBusyId,
                ),
            ],
          ],
        );
      },
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Container(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          Expanded(flex: 4, child: _HeaderText(s.laboratoryNameLabel)),
          Expanded(flex: 3, child: _HeaderText(s.laboratoryAdminLabel)),
          Expanded(flex: 2, child: _HeaderText(s.laboratoryBranchesLabel)),
          Expanded(flex: 2, child: _HeaderText(s.laboratoryStatusLabel)),
          SizedBox(
            width: LaboratoriesTable.actionsWidth,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _HeaderText(s.laboratoryActionsLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base
          .merge(AppTextStyles.caption)
          .copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.inkSubtle,
          ),
    );
  }
}

class _TableRow extends StatefulWidget {
  const _TableRow({
    required this.laboratory,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  final LaboratoryModel laboratory;
  final LaboratoryCallback onView;
  final LaboratoryCallback onEdit;
  final LaboratoryCallback onDelete;
  final LaboratoryCallback onToggleStatus;
  final int? statusBusyId;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final LaboratoryModel laboratory = widget.laboratory;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.resolve(context, AppMotion.fast),
        curve: AppMotion.curve,
        color: _hovered ? AppColors.ground : AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            Expanded(flex: 4, child: _NameCell(laboratory: laboratory)),
            Expanded(flex: 3, child: _AdminCell(admin: laboratory.admin)),
            Expanded(
              flex: 2,
              child: _BranchesCell(count: laboratory.branchesCount),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: LaboratoryStatusPill(isActive: laboratory.isActive),
              ),
            ),
            SizedBox(
              width: LaboratoriesTable.actionsWidth,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: LaboratoryRowActions(
                  laboratory: laboratory,
                  onView: () => widget.onView(laboratory),
                  onEdit: () => widget.onEdit(laboratory),
                  onDelete: () => widget.onDelete(laboratory),
                  onToggleStatus: () => widget.onToggleStatus(laboratory),
                  statusBusy: widget.statusBusyId == laboratory.id,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StackedRow extends StatelessWidget {
  const _StackedRow({
    required this.laboratory,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  final LaboratoryModel laboratory;
  final LaboratoryCallback onView;
  final LaboratoryCallback onEdit;
  final LaboratoryCallback onDelete;
  final LaboratoryCallback onToggleStatus;
  final int? statusBusyId;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _NameCell(laboratory: laboratory)),
              const SizedBox(width: AppSpacing.sm),
              LaboratoryStatusPill(isActive: laboratory.isActive),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _StackedField(
                  label: s.laboratoryAdminLabel,
                  child: _AdminCell(admin: laboratory.admin),
                ),
              ),
              Expanded(
                child: _StackedField(
                  label: s.laboratoryBranchesLabel,
                  child: _BranchesCell(count: laboratory.branchesCount),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LaboratoryRowActions(
              laboratory: laboratory,
              onView: () => onView(laboratory),
              onEdit: () => onEdit(laboratory),
              onDelete: () => onDelete(laboratory),
              onToggleStatus: () => onToggleStatus(laboratory),
              statusBusy: statusBusyId == laboratory.id,
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedField extends StatelessWidget {
  const _StackedField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[_HeaderText(label), const SizedBox(height: 2), child],
    );
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.laboratory});

  final LaboratoryModel laboratory;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Row(
      children: <Widget>[
        Container(
          width: AppSizes.controlSmall,
          height: AppSizes.controlSmall,
          decoration: const BoxDecoration(
            color: AppColors.brandWash,
            borderRadius: AppRadius.smAll,
          ),
          child: const Icon(
            Icons.biotech_outlined,
            size: AppSizes.iconMd,
            color: AppColors.brand600,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            laboratory.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: base
                .merge(AppTextStyles.body)
                .copyWith(fontWeight: FontWeight.w600, color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}

class _AdminCell extends StatelessWidget {
  const _AdminCell({required this.admin});

  final String? admin;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool hasAdmin = admin != null && admin!.trim().isNotEmpty;

    return Text(
      hasAdmin ? admin! : s.laboratoryAdminUnassigned,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(color: hasAdmin ? AppColors.inkMuted : AppColors.inkFaint),
    );
  }
}

class _BranchesCell extends StatelessWidget {
  const _BranchesCell({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Row(
      children: <Widget>[
        const Icon(
          Icons.account_tree_outlined,
          size: AppSizes.iconSm,
          color: AppColors.inkFaint,
        ),
        const SizedBox(width: AppSpacing.xs + 2),
        Text(
          '$count',
          style: base
              .merge(AppTextStyles.body)
              .copyWith(fontWeight: FontWeight.w500, color: AppColors.inkMuted),
        ),
      ],
    );
  }
}
