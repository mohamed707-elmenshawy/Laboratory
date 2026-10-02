class PhonePayload {
  const PhonePayload({
    this.id,
    required this.phone,
    required this.phoneCountry,
    required this.type,
  });

  final int? id;
  final String phone;
  final String phoneCountry;
  final String type;

  Map<String, dynamic> toJson() => <String, dynamic>{
    if (id != null) 'id': id,
    'phone': phone,
    'phone_country': phoneCountry,
    'type': type,
  };
}
