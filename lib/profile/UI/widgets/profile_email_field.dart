import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';

class ProfileEmailField extends StatefulWidget {
  const ProfileEmailField({super.key, required this.email});

  final String email;

  @override
  State<ProfileEmailField> createState() => _ProfileEmailFieldState();
}

class _ProfileEmailFieldState extends State<ProfileEmailField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.email,
  );

  @override
  void didUpdateWidget(ProfileEmailField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.email != widget.email) _controller.text = widget.email;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppTextField(
          label: s.emailLabel,
          controller: _controller,
          prefixIcon: Icons.mail_outline_rounded,
          enabled: false,
          textDirection: TextDirection.ltr,
        ),
        const SizedBox(height: AppSpacing.xs + 2),
        Row(
          children: <Widget>[
            const Icon(
              Icons.lock_outline_rounded,
              size: AppSizes.iconSm,
              color: AppColors.inkFaint,
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Expanded(
              child: Text(
                s.emailLockedHint,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(color: AppColors.inkSubtle),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
