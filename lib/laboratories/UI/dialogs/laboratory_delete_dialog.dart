import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/laboratory_model.dart';
import 'laboratory_dialog_shell.dart';

class LaboratoryDeleteDialog extends StatelessWidget {
  const LaboratoryDeleteDialog({super.key, required this.laboratory});

  final LaboratoryModel laboratory;

  static Future<void> show(
    BuildContext context,
    LaboratoryModel laboratory,
  ) => showDialog<void>(
    context: context,
    builder: (_) => LaboratoryDeleteDialog(laboratory: laboratory),
  );

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return LaboratoryDialogShell(
      title: s.deleteLaboratoryTitle,
      icon: Icons.delete_outline_rounded,
      actions: <Widget>[
        AppButton(
          label: s.cancel,
          size: AppButtonSize.medium,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(label: s.delete, size: AppButtonSize.medium, onPressed: null),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppAlert(
            feedback: AppFeedback.warning(
              title: s.uiOnlyTitle,
              message: s.uiOnlyMessage,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            s.deleteLaboratoryPrompt(laboratory.name),
            style: base
                .merge(AppTextStyles.body)
                .copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
