import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_text_styles.dart';

class AppTextLink extends StatefulWidget {
  const AppTextLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.fontSize = 13.5,
    this.fontWeight = FontWeight.w500,
    this.color = AppColors.brand600,
  });

  final String label;
  final VoidCallback? onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  @override
  State<AppTextLink> createState() => _AppTextLinkState();
}

class _AppTextLinkState extends State<AppTextLink> {
  bool _hovered = false;
  bool _focused = false;

  bool get _isEnabled => widget.onPressed != null;

  void _activate() => widget.onPressed?.call();

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;
    final bool underline = _isEnabled && (_hovered || _focused);

    return Semantics(
      button: true,
      link: true,
      enabled: _isEnabled,
      label: widget.label,
      child: FocusableActionDetector(
        enabled: _isEnabled,
        mouseCursor: _isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowHoverHighlight: (bool value) => setState(() => _hovered = value),
        onShowFocusHighlight: (bool value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: _isEnabled ? _activate : null,
          behavior: HitTestBehavior.opaque,
          child: ExcludeSemantics(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: AppRadius.smAll,
                boxShadow: _focused
                    ? AppShadows.focusRing(AppColors.focusRing)
                    : AppShadows.none,
              ),
              child: Text(
                widget.label,
                style: base
                    .merge(AppTextStyles.label)
                    .copyWith(
                      fontSize: widget.fontSize,
                      fontWeight: widget.fontWeight,
                      color: _isEnabled ? widget.color : AppColors.inkFaint,
                      decoration: underline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: widget.color,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
