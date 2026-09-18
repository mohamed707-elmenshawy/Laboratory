import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/localization/localization.dart';
import '../../../core/ui/ui.dart';
import '../../data/models/profile_model.dart';

class ProfilePhonesCard extends StatelessWidget {
  const ProfilePhonesCard({super.key, required this.phones});

  final List<ProfilePhone> phones;

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            s.phonesTitle,
            style: base
                .merge(AppTextStyles.label)
                .copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (phones.isEmpty)
            Text(
              s.phonesEmpty,
              style: base
                  .merge(AppTextStyles.body)
                  .copyWith(color: AppColors.inkSubtle),
            )
          else
            for (int i = 0; i < phones.length; i++) ...<Widget>[
              if (i > 0)
                const Divider(height: 1, thickness: 1, color: AppColors.line),
              _PhoneRow(phone: phones[i]),
            ],
        ],
      ),
    );
  }
}

class _PhoneRow extends StatelessWidget {
  const _PhoneRow({required this.phone});

  final ProfilePhone phone;

  String _typeLabel(AppStrings s) => switch (phone.type) {
    'both' => s.phoneTypeBoth,
    'phone' => s.phoneTypePhone,
    'whatsapp' => s.phoneTypeWhatsapp,
    _ => phone.type ?? '',
  };

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;
    final TextStyle base = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Icon(
            phone.type == 'whatsapp'
                ? Icons.chat_outlined
                : Icons.phone_outlined,
            size: AppSizes.iconMd,
            color: AppColors.inkSubtle,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              phone.phone,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.start,
              style: base
                  .merge(AppTextStyles.body)
                  .copyWith(fontWeight: FontWeight.w500, color: AppColors.ink),
            ),
          ),
          if (phone.phoneCountry != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: AppRadius.pill,
              ),
              child: Text(
                phone.phoneCountry!,
                style: base
                    .merge(AppTextStyles.caption)
                    .copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkSubtle,
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            _typeLabel(s),
            style: base
                .merge(AppTextStyles.caption)
                .copyWith(color: AppColors.inkSubtle),
          ),
        ],
      ),
    );
  }
}
