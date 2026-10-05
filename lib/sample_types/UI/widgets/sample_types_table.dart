import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/named_ref.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/sample_type_model.dart';

typedef SampleTypeCallback = void Function(SampleTypeModel sampleType);

class SampleTypesTable extends StatelessWidget {
  const SampleTypesTable({
    super.key,
    required this.sampleTypes,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  static const double _stackFrom = 900;
  static const double actionsWidth = 176;

  final List<SampleTypeModel> sampleTypes;
  final SampleTypeCallback onView;
  final SampleTypeCallback onEdit;
  final SampleTypeCallback onDelete;
  final SampleTypeCallback onToggleStatus;
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
            for (int i = 0; i < sampleTypes.length; i++) ...<Widget>[
              if (i > 0 || !stacked)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              if (stacked)
                _StackedRow(
                  sampleType: sampleTypes[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onToggleStatus: onToggleStatus,
                  statusBusyId: statusBusyId,
                )
              else
                _TableRow(
                  sampleType: sampleTypes[i],
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
          Expanded(flex: 4, child: _HeaderText(s.sampleTypeNameLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchLaboratoryLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchNameLabel)),
          Expanded(flex: 2, child: _HeaderText(s.laboratoryStatusLabel)),
          SizedBox(
            width: SampleTypesTable.actionsWidth,
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
    required this.sampleType,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  final SampleTypeModel sampleType;
  final SampleTypeCallback onView;
  final SampleTypeCallback onEdit;
  final SampleTypeCallback onDelete;
  final SampleTypeCallback onToggleStatus;
  final int? statusBusyId;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final SampleTypeModel sampleType = widget.sampleType;

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
            Expanded(flex: 4, child: _NameCell(sampleType: sampleType)),
            Expanded(flex: 3, child: _RefCell(value: sampleType.laboratory)),
            Expanded(flex: 3, child: _RefCell(value: sampleType.branch)),
            Expanded(
              flex: 2,
              child: _StatusCell(isActive: sampleType.isActive),
            ),
            SizedBox(
              width: SampleTypesTable.actionsWidth,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _RowActions(
                  sampleType: sampleType,
                  onView: () => widget.onView(sampleType),
                  onEdit: () => widget.onEdit(sampleType),
                  onDelete: () => widget.onDelete(sampleType),
                  onToggleStatus: () => widget.onToggleStatus(sampleType),
                  statusBusy: widget.statusBusyId == sampleType.id,
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
    required this.sampleType,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  final SampleTypeModel sampleType;
  final SampleTypeCallback onView;
  final SampleTypeCallback onEdit;
  final SampleTypeCallback onDelete;
  final SampleTypeCallback onToggleStatus;
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
              Expanded(child: _NameCell(sampleType: sampleType)),
              const SizedBox(width: AppSpacing.sm),
              _StatusCell(isActive: sampleType.isActive),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _StackedField(
                  label: s.branchLaboratoryLabel,
                  child: _RefCell(value: sampleType.laboratory),
                ),
              ),
              Expanded(
                child: _StackedField(
                  label: s.branchNameLabel,
                  child: _RefCell(value: sampleType.branch),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _RowActions(
              sampleType: sampleType,
              onView: () => onView(sampleType),
              onEdit: () => onEdit(sampleType),
              onDelete: () => onDelete(sampleType),
              onToggleStatus: () => onToggleStatus(sampleType),
              statusBusy: statusBusyId == sampleType.id,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions({
    required this.sampleType,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusy,
  });

  final SampleTypeModel sampleType;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final bool statusBusy;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool isActive = sampleType.isActive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (statusBusy)
          const SizedBox(
            width: AppSizes.hitTarget,
            height: AppSizes.hitTarget,
            child: Center(
              child: SizedBox(
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.brand600,
                ),
              ),
            ),
          )
        else
          _RowAction(
            icon: isActive
                ? Icons.toggle_on_rounded
                : Icons.toggle_off_outlined,
            tooltip: isActive ? s.deactivate : s.activate,
            iconSize: AppSizes.iconLg,
            color: isActive ? AppColors.success : AppColors.inkFaint,
            onPressed: onToggleStatus,
          ),
        _RowAction(
          icon: Icons.visibility_outlined,
          tooltip: s.view,
          onPressed: onView,
        ),
        _RowAction(
          icon: Icons.edit_outlined,
          tooltip: s.edit,
          onPressed: onEdit,
        ),
        _RowAction(
          icon: Icons.delete_outline_rounded,
          tooltip: s.delete,
          color: AppColors.danger,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.iconSize = AppSizes.iconMd,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: iconSize,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.hitTarget,
        height: AppSizes.hitTarget,
      ),
      hoverColor: AppColors.brandWash,
      icon: Icon(icon, color: color ?? AppColors.inkMuted),
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
  const _NameCell({required this.sampleType});

  final SampleTypeModel sampleType;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool hasDescription =
        sampleType.description?.trim().isNotEmpty == true;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                sampleType.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
              ),
              Text(
                hasDescription ? sampleType.description! : s.noDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RefCell extends StatelessWidget {
  const _RefCell({required this.value});

  final NamedRef? value;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool has = value != null && value!.name.trim().isNotEmpty;

    return Text(
      has ? value!.name : s.notAssigned,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(color: has ? AppColors.inkMuted : AppColors.inkFaint),
    );
  }
}

class _StatusCell extends StatelessWidget {
  const _StatusCell({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppPill(
        label: isActive ? s.statusActive : s.statusInactive,
        tone: isActive ? AppPillTone.success : AppPillTone.neutral,
        icon: isActive
            ? Icons.check_circle_rounded
            : Icons.pause_circle_outline_rounded,
      ),
    );
  }
}
