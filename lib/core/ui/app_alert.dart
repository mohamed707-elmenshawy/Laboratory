import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';
import 'app_feedback.dart';

class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.feedback,
    this.onDismiss,
    this.dismissTooltip,
  });

  final AppFeedback feedback;

  final VoidCallback? onDismiss;
  final String? dismissTooltip;

  @override
  Widget build(BuildContext context) {
    final AppFeedbackKind kind = feedback.kind;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: kind.background,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: kind.border, width: AppSizes.borderWidth),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(
                feedback.icon ?? kind.defaultIcon,
                size: AppSizes.iconMd,
                color: kind.foreground,
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    feedback.title,
                    style: base
                        .merge(AppTextStyles.label)
                        .copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: kind.foreground,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    feedback.message,
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(
                          fontSize: 12.8,
                          height: 1.5,
                          color: AppColors.inkMuted,
                        ),
                  ),
                  if (feedback.hasAction) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    _AlertAction(
                      label: feedback.actionLabel!,
                      color: kind.foreground,
                      onPressed: feedback.onAction!,
                    ),
                  ],
                ],
              ),
            ),
            if (onDismiss != null) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: onDismiss,
                tooltip: dismissTooltip,
                iconSize: AppSizes.iconMd,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: AppSizes.hitTarget,
                  height: AppSizes.hitTarget,
                ),
                icon: Icon(Icons.close_rounded, color: kind.foreground),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertAction extends StatefulWidget {
  const _AlertAction({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  State<_AlertAction> createState() => _AlertActionState();
}

class _AlertActionState extends State<_AlertAction> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: (bool value) => setState(() => _focused = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed();
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Semantics(
          button: true,
          label: widget.label,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: AppRadius.smAll,
              border: Border.all(
                color: _focused ? widget.color : const Color(0x00000000),
              ),
            ),
            child: Text(
              widget.label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12.8,
                fontWeight: FontWeight.w600,
                color: widget.color,
                decoration: TextDecoration.underline,
                decorationColor: widget.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
