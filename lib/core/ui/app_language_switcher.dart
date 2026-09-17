import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_motion.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_text_styles.dart';
import '../localization/app_locale.dart';

class AppLanguageSwitcher extends StatelessWidget {
  const AppLanguageSwitcher({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.enabled = true,
  });

  final AppLocale value;
  final ValueChanged<AppLocale> onChanged;
  final String semanticLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        height: AppSizes.controlSmall,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: AppColors.line,
            width: AppSizes.borderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final AppLocale locale in AppLocale.values)
              _Segment(
                label: locale.nativeName,
                selected: locale == value,
                enabled: enabled,
                arabic: locale.isRtl,
                onTap: () => onChanged(locale),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatefulWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.arabic,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final bool arabic;
  final VoidCallback onTap;

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment> {
  bool _hovered = false;
  bool _focused = false;

  void _activate() {
    if (!widget.enabled || widget.selected) return;
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = switch ((widget.selected, _hovered)) {
      (true, _) => AppColors.brand600,
      (false, true) => AppColors.surfaceMuted,
      _ => const Color(0x00000000),
    };

    return Semantics(
      button: true,
      selected: widget.selected,
      enabled: widget.enabled,
      label: widget.label,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        mouseCursor: widget.enabled && !widget.selected
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
          onTap: _activate,
          behavior: HitTestBehavior.opaque,
          child: ExcludeSemantics(
            child: AnimatedContainer(
              duration: AppMotion.resolve(context, AppMotion.fast),
              curve: AppMotion.curve,
              height: AppSizes.controlSmall,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                boxShadow: _focused
                    ? AppShadows.focusRing(AppColors.focusRing)
                    : AppShadows.none,
              ),
              child: Text(
                widget.label,
                style: AppTextStyles.label.copyWith(
                  fontSize: 12.5,
                  fontWeight: widget.selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: widget.selected
                      ? AppColors.onBrand
                      : AppColors.inkSubtle,
                  fontFamily: widget.arabic
                      ? AppTextStyles.familyArabic
                      : AppTextStyles.family,
                  fontFamilyFallback: widget.arabic
                      ? AppTextStyles.fallbackArabic
                      : AppTextStyles.fallback,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
