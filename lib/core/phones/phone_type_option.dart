import 'package:equatable/equatable.dart';

import '../localization/app_strings.dart';

class PhoneTypeOption extends Equatable {
  const PhoneTypeOption({required this.value, required this.label});

  factory PhoneTypeOption.fromJson(Map<String, dynamic> json) =>
      PhoneTypeOption(
        value: json['value']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
      );

  final String value;
  final String label;

  static const String fallbackValue = 'phone';

  static List<PhoneTypeOption> defaults(AppStrings s) => <PhoneTypeOption>[
    PhoneTypeOption(value: 'both', label: s.phoneTypeBoth),
    PhoneTypeOption(value: 'phone', label: s.phoneTypePhone),
    PhoneTypeOption(value: 'whatsapp', label: s.phoneTypeWhatsapp),
  ];

  @override
  List<Object?> get props => <Object?>[value, label];
}
