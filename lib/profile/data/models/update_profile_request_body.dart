class UpdateProfilePhone {
  const UpdateProfilePhone({
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

class UpdateProfileRequestBody {
  const UpdateProfileRequestBody({required this.name, required this.phones});

  final String name;
  final List<UpdateProfilePhone> phones;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'phones': phones.isEmpty
        ? null
        : phones
              .map((UpdateProfilePhone phone) => phone.toJson())
              .toList(growable: false),
  };
}
