import '../../../core/models/user_model.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.tenantId,
    required this.branchId,
    this.phones = const <ProfilePhone>[],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'] as int? ?? 0,
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    tenantId: json['tenant_id'] as String?,
    branchId: json['branch_id'] as int?,
    phones: switch (json['phones']) {
      final List<dynamic> list =>
        list
            .whereType<Map<dynamic, dynamic>>()
            .map(
              (Map<dynamic, dynamic> e) =>
                  ProfilePhone.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList(),
      _ => const <ProfilePhone>[],
    },
  );

  final int id;
  final String name;
  final String email;
  final String? tenantId;
  final int? branchId;
  final List<ProfilePhone> phones;

  UserModel toUser() => UserModel(
    id: id,
    name: name,
    email: email,
    tenantId: tenantId,
    branchId: branchId,
  );
}

class ProfilePhone {
  const ProfilePhone({
    required this.id,
    required this.phone,
    this.phoneCountry,
    this.type,
    this.dialCode,
  });

  factory ProfilePhone.fromJson(Map<String, dynamic> json) => ProfilePhone(
    id: json['id'] as int? ?? 0,
    phone: json['phone'] as String? ?? '',
    phoneCountry: json['phone_country'] as String?,
    type: json['type'] as String?,
    dialCode: json['dial_code'] as String?,
  );

  final int id;
  final String phone;
  final String? phoneCountry;
  final String? type;
  final String? dialCode;
}
