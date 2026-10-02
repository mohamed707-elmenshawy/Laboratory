import '../../../core/phones/phones.dart';

class UpdateBranchRequestBody {
  const UpdateBranchRequestBody({
    required this.lang,
    required this.name,
    required this.laboratoryId,
    required this.isMainBranch,
    required this.address,
    required this.phones,
  });

  final String lang;
  final String name;
  final int laboratoryId;
  final bool isMainBranch;
  final String address;
  final List<PhonePayload> phones;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lang': lang,
    'name': name,
    'laboratory_id': laboratoryId,
    'is_main_branch': isMainBranch,
    'address': address.isEmpty ? null : address,
    'phones': phones.isEmpty
        ? null
        : phones
              .map((PhonePayload phone) => phone.toJson())
              .toList(growable: false),
  };
}
