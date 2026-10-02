import 'package:flutter/widgets.dart';

import 'phone_country.dart';
import 'phone_payload.dart';
import 'phone_type_option.dart';

class PhoneDraft {
  PhoneDraft({
    this.id,
    String phone = '',
    String? country,
    String? type,
    this.dialCode,
  }) : controller = TextEditingController(text: phone),
       country = (country == null || country.isEmpty)
           ? PhoneCountry.fallbackCode
           : country.toUpperCase(),
       type = (type == null || type.isEmpty)
           ? PhoneTypeOption.fallbackValue
           : type;

  factory PhoneDraft.fromJson(Map<String, dynamic> json) => PhoneDraft(
    id: switch (json['id']) {
      final int id when id > 0 => id,
      _ => null,
    },
    phone: json['phone']?.toString() ?? '',
    country: json['phone_country']?.toString(),
    type: json['type']?.toString(),
    dialCode: json['dial_code']?.toString(),
  );

  final int? id;
  final TextEditingController controller;
  final String? dialCode;

  String country;
  String type;

  String get phone =>
      controller.text.trim().replaceAll(RegExp(r'[\s\-()]'), '');

  bool get isEmpty => phone.isEmpty;

  PhonePayload toPayload() =>
      PhonePayload(id: id, phone: phone, phoneCountry: country, type: type);

  void dispose() => controller.dispose();
}
