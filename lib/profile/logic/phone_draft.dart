import 'package:flutter/widgets.dart';

import '../data/models/phone_country.dart';
import '../data/models/phone_type_option.dart';
import '../data/models/profile_model.dart';
import '../data/models/update_profile_request_body.dart';

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

  factory PhoneDraft.fromPhone(ProfilePhone phone) => PhoneDraft(
    id: phone.id == 0 ? null : phone.id,
    phone: phone.phone,
    country: phone.phoneCountry,
    type: phone.type,
    dialCode: phone.dialCode,
  );

  final int? id;
  final TextEditingController controller;
  final String? dialCode;

  String country;
  String type;

  String get phone =>
      controller.text.trim().replaceAll(RegExp(r'[\s\-()]'), '');

  bool get isEmpty => phone.isEmpty;

  UpdateProfilePhone toRequest() => UpdateProfilePhone(
    id: id,
    phone: phone,
    phoneCountry: country,
    type: type,
  );

  void dispose() => controller.dispose();
}
