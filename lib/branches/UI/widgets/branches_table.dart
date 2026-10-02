import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/branch_model.dart';
import 'branch_row_actions.dart';

typedef BranchCallback = void Function(BranchModel branch);

class BranchesTable extends StatelessWidget {
  const BranchesTable({
    super.key,
    required this.branches,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  static const double _stackFrom = 920;
  static const double actionsWidth = 136;

  final List<BranchModel> branches;
  final BranchCallback onView;
  final BranchCallback onEdit;
  final BranchCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < _stackFrom;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (!stacked) const _HeaderRow(),
            for (int i = 0; i < branches.length; i++) ...<Widget>[
              if (i > 0 || !stacked)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              if (stacked)
                _StackedRow(
                  branch: branches[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
                )
              else
                _TableRow(
                  branch: branches[i],
                  onView: onView,
                  onEdit: onEdit,
                  onDelete: onDelete,
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
          Expanded(flex: 4, child: _HeaderText(s.branchNameLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchLaboratoryLabel)),
          Expanded(flex: 3, child: _HeaderText(s.branchPhonesLabel)),
          Expanded(flex: 2, child: _HeaderText(s.laboratoryStatusLabel)),
          SizedBox(
            width: BranchesTable.actionsWidth,
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
    required this.branch,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final BranchModel branch;
  final BranchCallback onView;
  final BranchCallback onEdit;
  final BranchCallback onDelete;

  @override
  State<_TableRow> createState() => _TableRowState();
}

class _TableRowState extends State<_TableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final BranchModel branch = widget.branch;

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
            Expanded(flex: 4, child: _NameCell(branch: branch)),
            Expanded(
              flex: 3,
              child: _MutedText(branch.laboratory?.name ?? '—'),
            ),
            Expanded(flex: 3, child: _PhonesCell(branch: branch)),
            Expanded(flex: 2, child: _StatusCell(isActive: branch.isActive)),
            SizedBox(
              width: BranchesTable.actionsWidth,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: BranchRowActions(
                  onView: () => widget.onView(branch),
                  onEdit: () => widget.onEdit(branch),
                  onDelete: () => widget.onDelete(branch),
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
    required this.branch,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final BranchModel branch;
  final BranchCallback onView;
  final BranchCallback onEdit;
  final BranchCallback onDelete;

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
              Expanded(child: _NameCell(branch: branch)),
              const SizedBox(width: AppSpacing.sm),
              _StatusCell(isActive: branch.isActive),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _StackedField(
                  label: s.branchLaboratoryLabel,
                  child: _MutedText(branch.laboratory?.name ?? '—'),
                ),
              ),
              Expanded(
                child: _StackedField(
                  label: s.branchPhonesLabel,
                  child: _PhonesCell(branch: branch),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: BranchRowActions(
              onView: () => onView(branch),
              onEdit: () => onEdit(branch),
              onDelete: () => onDelete(branch),
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
  const _NameCell({required this.branch});

  final BranchModel branch;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
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
            Icons.store_mall_directory_outlined,
            size: AppSizes.iconMd,
            color: AppColors.brand600,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                branch.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: base
                    .merge(AppTextStyles.body)
                    .copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
              ),
              if (branch.address?.isNotEmpty == true)
                Text(
                  branch.address!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: base
                      .merge(AppTextStyles.caption)
                      .copyWith(color: AppColors.inkFaint),
                ),
            ],
          ),
        ),
        if (branch.isMainBranch) ...<Widget>[
          const SizedBox(width: AppSpacing.sm),
          AppPill(
            label: s.branchMainPill,
            tone: AppPillTone.brand,
            icon: Icons.star_rounded,
          ),
        ],
      ],
    );
  }
}

class _PhonesCell extends StatelessWidget {
  const _PhonesCell({required this.branch});

  final BranchModel branch;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    if (branch.phones.isEmpty) {
      return _MutedText(s.phonesEmptyShort);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          branch.phones.first.phone,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.start,
          style: base
              .merge(AppTextStyles.body)
              .copyWith(fontWeight: FontWeight.w500, color: AppColors.inkMuted),
        ),
        if (branch.phones.length > 1)
          Text(
            s.branchPhonesCount(branch.phones.length),
            style: base
                .merge(AppTextStyles.caption)
                .copyWith(color: AppColors.inkFaint),
          ),
      ],
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

class _MutedText extends StatelessWidget {
  const _MutedText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: base.merge(AppTextStyles.body).copyWith(color: AppColors.inkMuted),
    );
  }
}
