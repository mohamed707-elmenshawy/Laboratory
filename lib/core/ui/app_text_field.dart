import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_motion.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.focusNode,
    this.prefixIcon,
    this.suffix,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.textDirection,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.maxLength,
    this.semanticLabel,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final IconData? prefixIcon;

  final Widget? suffix;

  final String? errorText;

  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  final TextDirection? textDirection;

  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final int? maxLength;
  final String? semanticLabel;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _internalNode;
  bool _hovered = false;
  bool _focused = false;

  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _internalNode?.removeListener(_onFocusChange);
      _node.addListener(_onFocusChange);
      _focused = _node.hasFocus;
    }
  }

  void _onFocusChange() {
    if (!mounted) return;
    if (_node.hasFocus != _focused) setState(() => _focused = _node.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    _internalNode?.removeListener(_onFocusChange);
    _internalNode?.dispose();
    super.dispose();
  }

  bool get _hasError => widget.errorText != null;

  Color get _borderColor {
    if (!widget.enabled) return AppColors.line;
    if (_hasError) return AppColors.danger;
    if (_focused) return AppColors.brand600;
    if (_hovered) return AppColors.lineStrong;
    return AppColors.line;
  }

  List<BoxShadow> get _shadow {
    if (!_focused || !widget.enabled) return AppShadows.none;
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
          color: widget.enabled ? AppColors.ink : AppColors.inkFaint,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: base
              .merge(AppTextStyles.label)
              .copyWith(
                color: widget.enabled ? AppColors.inkMuted : AppColors.inkFaint,
              ),
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.text
              : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: AppMotion.resolve(context, AppMotion.fast),
            curve: AppMotion.curve,
            height: AppSizes.controlLarge,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: widget.enabled
                  ? AppColors.surface
                  : AppColors.surfaceMuted,
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: _borderColor,
                width: AppSizes.borderWidth,
              ),
              boxShadow: _shadow,
            ),
            child: Row(
              children: <Widget>[
                if (widget.prefixIcon != null) ...<Widget>[
                  Icon(
                    widget.prefixIcon,
                    size: AppSizes.iconMd,
                    color: _focused && widget.enabled
                        ? AppColors.inkSubtle
                        : AppColors.inkFaint,
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                ],
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _node,
                    enabled: widget.enabled,
                    obscureText: widget.obscureText,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    autofillHints: widget.enabled ? widget.autofillHints : null,
                    textDirection: widget.textDirection,
                    autofocus: widget.autofocus,
                    maxLength: widget.maxLength,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    onSubmitted: widget.onSubmitted,
                    onChanged: widget.onChanged,
                    style: valueStyle,
                    cursorColor: AppColors.brand600,
                    cursorWidth: 1.5,
                    cursorRadius: const Radius.circular(1),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      counterText: '',
                      hintText: widget.hint,
                      hintStyle: valueStyle.copyWith(color: AppColors.inkFaint),
                    ),
                  ),
                ),
                if (widget.suffix != null) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  widget.suffix!,
                ],
              ],
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
