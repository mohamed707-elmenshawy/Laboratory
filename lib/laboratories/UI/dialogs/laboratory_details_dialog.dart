import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/laboratory_model.dart';
import '../widgets/laboratory_status_pill.dart';
import 'laboratory_dialog_shell.dart';

class LaboratoryDetailsDialog extends StatelessWidget {
  const LaboratoryDetailsDialog({super.key, required this.laboratory});

  final LaboratoryModel laboratory;

  static Future<void> show(
    BuildContext context,
    LaboratoryModel laboratory,
  ) => showDialog<void>(
    context: context,
    builder: (_) => LaboratoryDetailsDialog(laboratory: laboratory),
  );

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return LaboratoryDialogShell(
      title: s.laboratoryDetailsTitle,
      icon: Icons.biotech_outlined,
      actions: <Widget>[
        AppButton(
          label: s.close,
          size: AppButtonSize.medium,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _DetailRow(
            label: s.laboratoryNameLabel,
            child: _DetailText(laboratory.name, strong: true),
          ),
          _DetailRow(
            label: s.laboratoryIdLabel,
            child: _DetailText('${laboratory.id}'),
          ),
          _DetailRow(
            label: s.laboratoryAdminLabel,
            child: _DetailText(
              laboratory.admin?.trim().isNotEmpty == true
                  ? laboratory.admin!
                  : s.laboratoryAdminUnassigned,
            ),
          ),
          _DetailRow(
            label: s.laboratoryBranchesLabel,
            child: _DetailText('${laboratory.branchesCount}'),
          ),
          _DetailRow(
            label: s.laboratoryStatusLabel,
            child: LaboratoryStatusPill(isActive: laboratory.isActive),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child});

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
            width: 120,
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

class _DetailText extends StatelessWidget {
  const _DetailText(this.value, {this.strong = false});

  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Text(
      value,
      style: base
          .merge(AppTextStyles.body)
          .copyWith(
            fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
            color: strong ? AppColors.ink : AppColors.inkMuted,
          ),
    );
  }
}
