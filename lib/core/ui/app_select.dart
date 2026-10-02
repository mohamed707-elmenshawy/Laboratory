import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_motion.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';

class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label, this.child});

  final T value;
  final String label;
  final Widget? child;
}

class AppSelect<T> extends StatefulWidget {
  const AppSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.hideLabel = false,
    this.height = AppSizes.controlLarge,
  });

  final String label;
  final T? value;
  final List<AppSelectOption<T>> options;
  final ValueChanged<T>? onChanged;
  final String? errorText;
  final bool enabled;
  final bool hideLabel;
  final double height;

  @override
  State<AppSelect<T>> createState() => _AppSelectState<T>();
}

class _AppSelectState<T> extends State<AppSelect<T>> {
  bool _hovered = false;
  bool _focused = false;

  bool get _isEnabled => widget.enabled && widget.onChanged != null;
  bool get _hasError => widget.errorText != null;

  Color get _borderColor {
    if (!_isEnabled) return AppColors.line;
    if (_hasError) return AppColors.danger;
    if (_focused) return AppColors.brand600;
    if (_hovered) return AppColors.lineStrong;
    return AppColors.line;
  }

  List<BoxShadow> get _shadow {
    if (!_focused || !_isEnabled) return AppShadows.none;
    return AppShadows.focusRing(
      _hasError ? AppColors.dangerRing : AppColors.focusRing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;
    final TextStyle valueStyle = base
        .merge(AppTextStyles.bodyLarge)
        .copyWith(
          fontSize: 14.5,
          color: _isEnabled ? AppColors.ink : AppColors.inkFaint,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!widget.hideLabel) ...<Widget>[
          Text(
            widget.label,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  color: _isEnabled ? AppColors.inkMuted : AppColors.inkFaint,
                ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
        ],
        MouseRegion(
          cursor: _isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: AppMotion.resolve(context, AppMotion.fast),
            curve: AppMotion.curve,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _isEnabled ? AppColors.surface : AppColors.surfaceMuted,
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: _borderColor,
                width: AppSizes.borderWidth,
              ),
              boxShadow: _shadow,
            ),
            child: Focus(
              onFocusChange: (bool value) => setState(() => _focused = value),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: widget.value,
                  isExpanded: true,
                  isDense: true,
                  borderRadius: AppRadius.mdAll,
                  focusColor: const Color(0x00000000),
                  dropdownColor: AppColors.surface,
                  style: valueStyle,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: AppSizes.iconMd,
                    color: _isEnabled
                        ? AppColors.inkSubtle
                        : AppColors.inkFaint,
                  ),
                  selectedItemBuilder: (BuildContext context) => widget.options
                      .map(
                        (AppSelectOption<T> option) => Align(
                          alignment: AlignmentDirectional.centerStart,
                          child:
                              option.child ??
                              Text(
                                option.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: valueStyle,
                              ),
                        ),
                      )
                      .toList(growable: false),
                  items: widget.options
                      .map(
                        (AppSelectOption<T> option) => DropdownMenuItem<T>(
                          value: option.value,
                          child:
                              option.child ??
                              Text(
                                option.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: valueStyle,
                              ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: _isEnabled
                      ? (T? value) {
                          if (value != null) widget.onChanged!(value);
                        }
                      : null,
                ),
              ),
            ),
          ),
        ),
        if (_hasError) ...<Widget>[
          const SizedBox(height: AppSpacing.xs + 2),
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.error_outline_rounded,
                    size: AppSizes.iconSm,
                    color: AppColors.danger,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs + 2),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: base
                        .merge(AppTextStyles.caption)
                        .copyWith(fontSize: 12.5, color: AppColors.danger),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
