import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/laboratory_model.dart';
import 'laboratory_dialog_shell.dart';

class LaboratoryFormDialog extends StatefulWidget {
  const LaboratoryFormDialog({super.key, this.laboratory});

  final LaboratoryModel? laboratory;

  static Future<void> show(
    BuildContext context, {
    LaboratoryModel? laboratory,
  }) => showDialog<void>(
    context: context,
    builder: (_) => LaboratoryFormDialog(laboratory: laboratory),
  );

  @override
  State<LaboratoryFormDialog> createState() => _LaboratoryFormDialogState();
}

class _LaboratoryFormDialogState extends State<LaboratoryFormDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.laboratory?.name ?? '',
  );
  late bool _isActive = widget.laboratory?.isActive ?? true;

  bool get _isEditing => widget.laboratory != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return LaboratoryDialogShell(
      title: _isEditing ? s.editLaboratoryTitle : s.createLaboratoryTitle,
      icon: _isEditing ? Icons.edit_outlined : Icons.add_circle_outline_rounded,
      actions: <Widget>[
        AppButton(
          label: s.cancel,
          size: AppButtonSize.medium,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: _isEditing ? s.save : s.create,
          size: AppButtonSize.medium,
          onPressed: null,
        ),
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
          AppTextField(
            label: s.laboratoryNameLabel,
            hint: s.laboratoryNameHint,
            controller: _nameController,
            prefixIcon: Icons.biotech_outlined,
            maxLength: 255,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCheckbox(
            value: _isActive,
            label: s.statusActive,
            onChanged: (bool value) => setState(() => _isActive = value),
          ),
        ],
      ),
    );
  }
}
