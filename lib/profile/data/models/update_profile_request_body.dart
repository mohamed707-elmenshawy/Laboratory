import '../../../core/phones/phones.dart';

class UpdateProfileRequestBody {
  const UpdateProfileRequestBody({required this.name, required this.phones});

  final String name;
  final List<PhonePayload> phones;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'phones': phones.isEmpty
        ? null
        : phones
              .map((PhonePayload phone) => phone.toJson())
              .toList(growable: false),
  };
}
