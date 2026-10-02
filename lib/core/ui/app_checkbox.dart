import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_motion.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';

class AppCheckbox extends StatefulWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.semanticLabel,
    this.semanticHint,
    this.enabled = true,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;

  final String? semanticLabel;

  final String? semanticHint;

  final bool enabled;

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool _hovered = false;
  bool _focused = false;

  bool get _isEnabled => widget.enabled && widget.onChanged != null;

  void _toggle() {
    if (!_isEnabled) return;
    widget.onChanged!.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;

    final Color borderColor = switch ((_isEnabled, widget.value, _hovered)) {
      (false, _, _) => AppColors.line,
      (_, true, _) => AppColors.brand600,
      (_, false, true) => AppColors.lineStrong,
      _ => AppColors.lineStrong,
    };

    return Semantics(
      checked: widget.value,
      enabled: _isEnabled,
      label: widget.semanticLabel ?? widget.label,
      hint: widget.semanticHint,
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
              _toggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: _isEnabled ? _toggle : null,
          behavior: HitTestBehavior.opaque,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: AppSizes.hitTarget,
                  height: AppSizes.hitTarget,
                  child: Center(
                    child: AnimatedContainer(
                      duration: AppMotion.resolve(context, AppMotion.fast),
                      curve: AppMotion.curve,
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: widget.value && _isEnabled
                            ? AppColors.brand600
                            : AppColors.surface,
                        borderRadius: AppRadius.smAll,
                        border: Border.all(color: borderColor, width: 1.5),
                        boxShadow: _focused
                            ? AppShadows.focusRing(AppColors.focusRing)
                            : AppShadows.none,
                      ),
                      child: widget.value
                          ? Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: _isEnabled
                                  ? AppColors.onBrand
                                  : AppColors.inkFaint,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.label,
                  style: base
                      .merge(AppTextStyles.label)
                      .copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: _isEnabled
                            ? AppColors.inkMuted
                            : AppColors.inkFaint,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
