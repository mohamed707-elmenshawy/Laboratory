import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/models/named_ref.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/parameter_model.dart';

typedef ParameterCallback = void Function(ParameterModel parameter);

class ParametersTable extends StatelessWidget {
  const ParametersTable({
    super.key,
    required this.parameters,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  static const double _stackFrom = 900;
  static const double actionsWidth = 176;

  final List<ParameterModel> parameters;
  final ParameterCallback onView;
  final ParameterCallback onEdit;
  final ParameterCallback onDelete;
  final ParameterCallback onToggleStatus;
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
            for (int i = 0; i < parameters.length; i++) ...<Widget>[
              if (i > 0 || !stacked)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              if (stacked)
                _StackedRow(
                  parameter: parameters[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                  onToggleStatus: onToggleStatus,
                  statusBusyId: statusBusyId,
                )
              else
                _TableRow(
                  parameter: parameters[i],
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
          Expanded(flex: 4, child: _HeaderText(s.parameterNameLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchLaboratoryLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchNameLabel)),
          Expanded(flex: 2, child: _HeaderText(s.laboratoryStatusLabel)),
          SizedBox(
            width: ParametersTable.actionsWidth,
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
    required this.parameter,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  final ParameterModel parameter;
  final ParameterCallback onView;
  final ParameterCallback onEdit;
  final ParameterCallback onDelete;
  final ParameterCallback onToggleStatus;
  final int? statusBusyId;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ParameterModel parameter = widget.parameter;

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
            Expanded(flex: 4, child: _NameCell(parameter: parameter)),
            Expanded(flex: 3, child: _RefCell(value: parameter.laboratory)),
            Expanded(flex: 3, child: _RefCell(value: parameter.branch)),
            Expanded(flex: 2, child: _StatusCell(isActive: parameter.isActive)),
            SizedBox(
              width: ParametersTable.actionsWidth,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: _RowActions(
                  parameter: parameter,
                  onView: () => widget.onView(parameter),
                  onEdit: () => widget.onEdit(parameter),
                  onDelete: () => widget.onDelete(parameter),
                  onToggleStatus: () => widget.onToggleStatus(parameter),
                  statusBusy: widget.statusBusyId == parameter.id,
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
    required this.parameter,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusyId,
  });

  final ParameterModel parameter;
  final ParameterCallback onView;
  final ParameterCallback onEdit;
  final ParameterCallback onDelete;
  final ParameterCallback onToggleStatus;
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
              Expanded(child: _NameCell(parameter: parameter)),
              const SizedBox(width: AppSpacing.sm),
              _StatusCell(isActive: parameter.isActive),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _StackedField(
                  label: s.branchLaboratoryLabel,
                  child: _RefCell(value: parameter.laboratory),
                ),
              ),
              Expanded(
                child: _StackedField(
                  label: s.branchNameLabel,
                  child: _RefCell(value: parameter.branch),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _RowActions(
              parameter: parameter,
              onView: () => onView(parameter),
              onEdit: () => onEdit(parameter),
              onDelete: () => onDelete(parameter),
              onToggleStatus: () => onToggleStatus(parameter),
              statusBusy: statusBusyId == parameter.id,
            ),
          ),
        ],
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions({
    required this.parameter,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    required this.statusBusy,
  });

  final ParameterModel parameter;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final bool statusBusy;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool isActive = parameter.isActive;

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
  const _NameCell({required this.parameter});

  final ParameterModel parameter;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool hasDescription =
        parameter.description?.trim().isNotEmpty == true;

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
                parameter.name,
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
                hasDescription ? parameter.description! : s.noDescription,
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
