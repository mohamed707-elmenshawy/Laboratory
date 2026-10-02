import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/design_system.dart';
import '../localization/localization.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.hint,
    required this.initialValue,
    required this.onSubmitted,
    this.externalValue,
    this.debounce = const Duration(milliseconds: 400),
  });

  final String hint;
  final String initialValue;
  final ValueChanged<String> onSubmitted;

  /// The term the owner currently holds, so the field can follow when it is
  /// cleared from elsewhere (an empty state's "Clear filters", for example).
  final String? externalValue;
  final Duration debounce;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    final String? external = widget.externalValue;
    if (external == null) return;
    if (_debounce?.isActive ?? false) return;
    if (_controller.text.trim() == external) return;

    _controller.text = external;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus != _focused) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, _apply);
  }

  void _apply() {
    _debounce?.cancel();
    widget.onSubmitted(_controller.text);
  }

  void _clear() {
    _controller.clear();
    setState(() {});
    _apply();
    _focusNode.requestFocus();
  }

  Color get _borderColor {
    if (_focused) return AppColors.brand600;
    if (_hovered) return AppColors.lineStrong;
    return AppColors.line;
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;
    final TextStyle valueStyle = base
        .merge(AppTextStyles.body)
        .copyWith(fontSize: 14, color: AppColors.ink);
    final bool hasText = _controller.text.isNotEmpty;

    return MouseRegion(
      cursor: SystemMouseCursors.text,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.resolve(context, AppMotion.fast),
        curve: AppMotion.curve,
        height: AppSizes.controlMedium,
        padding: const EdgeInsetsDirectional.only(
          start: AppSpacing.md,
          end: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: _borderColor, width: AppSizes.borderWidth),
          boxShadow: _focused
              ? AppShadows.focusRing(AppColors.focusRing)
              : AppShadows.none,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search_rounded,
              size: AppSizes.iconMd,
              color: _focused ? AppColors.inkSubtle : AppColors.inkFaint,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Semantics(
                label: widget.hint,
                textField: true,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: _onChanged,
                  onSubmitted: (_) => _apply(),
                  textInputAction: TextInputAction.search,
                  maxLength: 100,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                    counterText: '',
                    hintText: widget.hint,
                    hintStyle: valueStyle.copyWith(color: AppColors.inkFaint),
                  ),
                ),
              ),
            ),
            if (hasText)
              IconButton(
                onPressed: _clear,
                tooltip: s.clearSearch,
                iconSize: AppSizes.iconMd,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: AppSizes.controlSmall,
                  height: AppSizes.controlSmall,
                ),
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.inkSubtle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
