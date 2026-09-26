import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../data/models/laboratory_model.dart';

class LaboratoryRowActions extends StatelessWidget {
  const LaboratoryRowActions({
    super.key,
    required this.laboratory,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.statusBusy = false,
  });

  final LaboratoryModel laboratory;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final bool statusBusy;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool isActive = laboratory.isActive;

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
  final double iconSize;
  final VoidCallback onPressed;
  final Color? color;

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
