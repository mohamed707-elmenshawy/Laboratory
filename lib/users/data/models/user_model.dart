import 'package:equatable/equatable.dart';

import '../../../core/models/named_ref.dart';
import '../../../core/phones/phones.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
    required this.phones,
    this.emailVerifiedAt,
    this.tenantId,
    this.laboratory,
    this.branch,
    this.commissionPercentage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    emailVerifiedAt: json['email_verified_at']?.toString(),
    tenantId: json['tenant_id']?.toString(),
    laboratory: NamedRef.maybeFrom(json['laboratory']),
    branch: NamedRef.maybeFrom(json['branch']),
    commissionPercentage: (json['commission_percentage'] as num?)?.toDouble(),
    roles: _names(json['roles']),
    permissions: _names(json['permissions']),
    phones: switch (json['phones']) {
      final List<dynamic> phones =>
        phones
            .whereType<Map<dynamic, dynamic>>()
            .map(
              (Map<dynamic, dynamic> phone) =>
                  PhoneModel.fromJson(Map<String, dynamic>.from(phone)),
            )
            .toList(growable: false),
      _ => const <PhoneModel>[],
    },
  );

  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? tenantId;
  final NamedRef? laboratory;
  final NamedRef? branch;
  final double? commissionPercentage;
  final List<String> roles;
  final List<String> permissions;
  final List<PhoneModel> phones;

  bool get isVerified => emailVerifiedAt != null && emailVerifiedAt!.isNotEmpty;

  static List<String> _names(Object? value) => switch (value) {
    final List<dynamic> list =>
      list.map((dynamic item) => item.toString()).toList(growable: false),
    _ => const <String>[],
  };

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    email,
    emailVerifiedAt,
    tenantId,
    laboratory,
    branch,
    commissionPercentage,
    roles,
    permissions,
    phones,
  ];
}
