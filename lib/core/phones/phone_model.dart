import 'package:equatable/equatable.dart';

class PhoneModel extends Equatable {
  const PhoneModel({
    required this.id,
    required this.phone,
    this.phoneCountry,
    this.type,
    this.typeLabel,
    this.dialCode,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) => PhoneModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    phone: json['phone']?.toString() ?? '',
    phoneCountry: json['phone_country']?.toString(),
    type: json['type']?.toString(),
    typeLabel: json['type_label']?.toString(),
    dialCode: json['dial_code']?.toString(),
  );

  final int id;
  final String phone;
  final String? phoneCountry;
  final String? type;
  final String? typeLabel;
  final String? dialCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'phone': phone,
    'phone_country': phoneCountry,
    'type': type,
    'dial_code': dialCode,
  };

  @override
  List<Object?> get props => <Object?>[
    id,
    phone,
    phoneCountry,
    type,
    typeLabel,
    dialCode,
  ];
}
