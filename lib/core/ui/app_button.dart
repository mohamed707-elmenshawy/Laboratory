import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';
import '../design_system/app_motion.dart';
import '../design_system/app_radius.dart';
import '../design_system/app_shadows.dart';
import '../design_system/app_sizes.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

enum AppButtonVariant { primary, secondary, ghost }

enum AppButtonSize { large, medium, small }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.isSuccess = false,
    this.expand = false,
    this.icon,
    this.loadingLabel,
    this.successLabel,
  });

  final String label;

  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;

  final bool isLoading;

  final bool isSuccess;

  final bool expand;
  final IconData? icon;
  final String? loadingLabel;
  final String? successLabel;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _isBusy => widget.isLoading || widget.isSuccess;
  bool get _isEnabled => widget.onPressed != null && !_isBusy;

  void _activate() {
    if (!_isEnabled) return;
    widget.onPressed!.call();
  }

  double get _height => switch (widget.size) {
    AppButtonSize.large => AppSizes.controlLarge,
    AppButtonSize.medium => AppSizes.controlMedium,
    AppButtonSize.small => AppSizes.controlSmall,
  };

  double get _fontSize => switch (widget.size) {
    AppButtonSize.large => 15,
    AppButtonSize.medium => 14,
    AppButtonSize.small => 13,
  };

  double get _padding => switch (widget.size) {
    AppButtonSize.large => AppSpacing.xxl,
    AppButtonSize.medium => AppSpacing.xl,
    AppButtonSize.small => AppSpacing.md,
  };

  Color get _background {
    if (!_isEnabled) {
      return switch (widget.variant) {
        AppButtonVariant.primary => AppColors.surfaceSunken,
        AppButtonVariant.secondary => AppColors.surfaceMuted,
        AppButtonVariant.ghost => const Color(0x00000000),
      };
    }
    return switch (widget.variant) {
      AppButtonVariant.primary when _pressed => AppColors.brand800,
      AppButtonVariant.primary when _hovered => AppColors.brand700,
      AppButtonVariant.primary => AppColors.brand600,
      AppButtonVariant.secondary when _pressed => AppColors.surfaceSunken,
      AppButtonVariant.secondary when _hovered => AppColors.surfaceMuted,
      AppButtonVariant.secondary => AppColors.surface,
      AppButtonVariant.ghost when _pressed || _hovered => AppColors.brandWash,
      AppButtonVariant.ghost => const Color(0x00000000),
    };
  }

  Color get _foreground {
    if (!_isEnabled) return AppColors.inkFaint;
    return switch (widget.variant) {
      AppButtonVariant.primary => AppColors.onBrand,
      AppButtonVariant.secondary => AppColors.ink,
      AppButtonVariant.ghost => AppColors.brand600,
    };
  }

  Border? get _border => switch (widget.variant) {
    AppButtonVariant.secondary => Border.all(
      color: _isEnabled && _hovered ? AppColors.lineStrong : AppColors.line,
      width: AppSizes.borderWidth,
    ),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final TextStyle base = DefaultTextStyle.of(context).style;
    final String label = switch (widget) {
      AppButton(isSuccess: true) => widget.successLabel ?? widget.label,
      AppButton(isLoading: true) => widget.loadingLabel ?? widget.label,
      _ => widget.label,
    };

    final Widget content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.isLoading)
          _Spinner(color: _foreground)
        else if (widget.isSuccess)
          Icon(
            Icons.check_circle_rounded,
            size: AppSizes.iconMd,
            color: _foreground,
          )
        else if (widget.icon != null)
          Icon(widget.icon, size: AppSizes.iconMd, color: _foreground),
        if (widget.isLoading || widget.isSuccess || widget.icon != null)
          const SizedBox(width: AppSpacing.sm + 1),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: base
                .merge(AppTypography.button)
                .copyWith(fontSize: _fontSize, color: _foreground),
          ),
        ),
      ],
    );

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: label,
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
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: _isEnabled ? _activate : null,
          onTapDown: _isEnabled ? (_) => setState(() => _pressed = true) : null,
          onTapUp: _isEnabled ? (_) => setState(() => _pressed = false) : null,
          onTapCancel: _isEnabled
              ? () => setState(() => _pressed = false)
              : null,
          child: AnimatedContainer(
            duration: AppMotion.resolve(context, AppMotion.fast),
            curve: AppMotion.curve,
            height: _height,
            width: widget.expand ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: _padding),
            decoration: BoxDecoration(
              color: _background,
              borderRadius: AppRadius.mdAll,
              border: _border,
              boxShadow: _focused
                  ? AppShadows.focusRing(AppColors.focusRing)
                  : AppShadows.none,
            ),
            child: ExcludeSemantics(child: Center(child: content)),
          ),
        ),
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.iconSm + 2,
      height: AppSizes.iconSm + 2,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withValues(alpha: 0.28),
      ),
    );
  }
}
