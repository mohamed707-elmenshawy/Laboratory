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
  });

  final LaboratoryModel laboratory;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final bool isActive = laboratory.isActive;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Tooltip(
          message: isActive ? s.statusActive : s.statusInactive,
          child: SizedBox(
            width: AppSizes.hitTarget,
            height: AppSizes.hitTarget,
            child: Center(
              child: Icon(
                isActive ? Icons.toggle_on_rounded : Icons.toggle_off_outlined,
                size: AppSizes.iconLg,
                color: isActive ? AppColors.success : AppColors.inkFaint,
                semanticLabel: isActive ? s.statusActive : s.statusInactive,
              ),
            ),
          ),
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
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: AppSizes.iconMd,
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
