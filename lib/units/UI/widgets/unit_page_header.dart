import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';

class UnitPageHeader extends StatelessWidget {
  const UnitPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BackLink(
          label: s.backToUnits,
          icon: isRtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
          onPressed: onBack,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (leading != null) ...<Widget>[
              leading!,
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                title,
                style: base
                    .merge(AppTextStyles.h2)
                    .copyWith(color: AppColors.ink),
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs + 2),
                child: trailing,
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Text(
          subtitle,
          style: base
              .merge(AppTextStyles.body)
              .copyWith(color: AppColors.inkSubtle),
        ),
      ],
    );
  }
}

class _BackLink extends StatefulWidget {
  const _BackLink({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<_BackLink> createState() => _BackLinkState();
}

class _BackLinkState extends State<_BackLink> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;
    final Color color = _hovered ? AppColors.brand700 : AppColors.brand600;

    return Semantics(
      button: true,
      label: widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
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
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.smAll,
              border: Border.all(
                color: _focused ? AppColors.brand600 : const Color(0x00000000),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(widget.icon, size: AppSizes.iconSm, color: color),
                const SizedBox(width: AppSpacing.xs + 2),
                Text(
                  widget.label,
                  style: base
                      .merge(AppTextStyles.label)
                      .copyWith(fontWeight: FontWeight.w600, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
