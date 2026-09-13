import 'package:flutter/material.dart';

import '../design_system/app_colors.dart';

enum AppFeedbackKind { success, warning, danger }

@immutable
class AppFeedback {
  const AppFeedback({
    required this.kind,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  const AppFeedback.success({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) : this(
         kind: AppFeedbackKind.success,
         title: title,
         message: message,
         actionLabel: actionLabel,
         onAction: onAction,
         icon: icon,
       );

  const AppFeedback.warning({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) : this(
         kind: AppFeedbackKind.warning,
         title: title,
         message: message,
         actionLabel: actionLabel,
         onAction: onAction,
         icon: icon,
       );

  const AppFeedback.danger({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) : this(
         kind: AppFeedbackKind.danger,
         title: title,
         message: message,
         actionLabel: actionLabel,
         onAction: onAction,
         icon: icon,
       );

  final AppFeedbackKind kind;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  bool get hasAction => actionLabel != null && onAction != null;
}

extension AppFeedbackKindStyle on AppFeedbackKind {
  Color get foreground => switch (this) {
    AppFeedbackKind.success => AppColors.success,
    AppFeedbackKind.warning => AppColors.warning,
    AppFeedbackKind.danger => AppColors.danger,
  };

  Color get background => switch (this) {
    AppFeedbackKind.success => AppColors.successWash,
    AppFeedbackKind.warning => AppColors.warningWash,
    AppFeedbackKind.danger => AppColors.dangerWash,
  };

  Color get border => switch (this) {
    AppFeedbackKind.success => AppColors.successLine,
    AppFeedbackKind.warning => AppColors.warningLine,
    AppFeedbackKind.danger => AppColors.dangerLine,
  };

  IconData get defaultIcon => switch (this) {
    AppFeedbackKind.success => Icons.check_circle_outline_rounded,
    AppFeedbackKind.warning => Icons.warning_amber_rounded,
    AppFeedbackKind.danger => Icons.error_outline_rounded,
  };
}
