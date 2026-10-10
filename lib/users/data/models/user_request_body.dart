import '../../../core/phones/phones.dart';

class UserRequestBody {
  const UserRequestBody({
    required this.name,
    required this.email,
    required this.roles,
    required this.phones,
    this.password = '',
    this.passwordConfirmation = '',
    this.laboratoryId,
    this.branchId,
    this.commissionPercentage,
    this.permissions = const <String>[],
    this.sendPermissions = false,
  });

  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final List<String> roles;
  final List<PhonePayload> phones;
  final int? laboratoryId;
  final int? branchId;
  final double? commissionPercentage;
  final List<String> permissions;
  final bool sendPermissions;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'email': email,
    if (password.isNotEmpty) ...<String, dynamic>{
      'password': password,
      'password_confirmation': passwordConfirmation,
    },
    'roles': roles,
    'laboratory_id': laboratoryId,
    'branch_id': branchId,
    'commission_percentage': commissionPercentage,
    if (sendPermissions) 'permissions': permissions,
    'phones': phones.isEmpty
        ? null
        : phones
              .map((PhonePayload phone) => phone.toJson())
              .toList(growable: false),
  };
}
