import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_sizes.dart';
import 'app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    required this.showPasswordLabel,
    required this.hidePasswordLabel,
    this.hint,
    this.controller,
    this.focusNode,
    this.prefixIcon = Icons.lock_outline_rounded,
    this.errorText,
    this.enabled = true,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
  });

  final String label;

  final String showPasswordLabel;

  final String hidePasswordLabel;

  final String? hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final IconData? prefixIcon;
  final String? errorText;
  final bool enabled;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final String toggleLabel = _obscured
        ? widget.showPasswordLabel
        : widget.hidePasswordLabel;

    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      focusNode: widget.focusNode,
      prefixIcon: widget.prefixIcon,
      errorText: widget.errorText,
      enabled: widget.enabled,
      obscureText: _obscured,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus,
      suffix: IconButton(
        onPressed: widget.enabled
            ? () => setState(() => _obscured = !_obscured)
            : null,
        tooltip: toggleLabel,
        iconSize: AppSizes.iconMd,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        constraints: const BoxConstraints.tightFor(
          width: AppSizes.hitTarget,
          height: AppSizes.hitTarget,
        ),
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.inkFaint;
            }
            if (states.contains(WidgetState.hovered) ||
                states.contains(WidgetState.focused)) {
              return AppColors.ink;
            }
            return AppColors.inkSubtle;
          }),
          overlayColor: const WidgetStatePropertyAll<Color>(Color(0x00000000)),
        ),
        icon: Semantics(
          label: toggleLabel,
          child: Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}
