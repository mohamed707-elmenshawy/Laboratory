import 'package:equatable/equatable.dart';

import '../../../core/models/user_model.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.tenantId,
    required this.branchId,
    this.phones = const <ProfilePhone>[],
    this.roles = const <String>[],
    this.permissions = const <String>[],
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
    roles: _names(json['roles']),
    permissions: _names(json['permissions']),
  );

  final int id;
  final String name;
  final String email;
  final String? tenantId;
  final int? branchId;
  final List<ProfilePhone> phones;
  final List<String> roles;
  final List<String> permissions;

  bool get isSuperAdmin => roles.contains('super-admin');

  UserModel toUser() => UserModel(
    id: id,
    name: name,
    email: email,
    tenantId: tenantId,
    branchId: branchId,
  );
}

List<String> _names(Object? value) => switch (value) {
  final List<dynamic> list => list
      .map((dynamic item) => item.toString())
      .toList(growable: false),
  _ => const <String>[],
};

class ProfilePhone extends Equatable {
  const ProfilePhone({
    required this.id,
    required this.phone,
    this.phoneCountry,
    this.type,
    this.typeLabel,
    this.dialCode,
  });

  factory ProfilePhone.fromJson(Map<String, dynamic> json) => ProfilePhone(
    id: json['id'] as int? ?? 0,
    phone: json['phone'] as String? ?? '',
    phoneCountry: json['phone_country'] as String?,
    type: json['type'] as String?,
    typeLabel: json['type_label'] as String?,
    dialCode: json['dial_code'] as String?,
  );

  final int id;
  final String phone;
  final String? phoneCountry;
  final String? type;
  final String? typeLabel;
  final String? dialCode;

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
