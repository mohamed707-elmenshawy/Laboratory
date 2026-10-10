import 'package:equatable/equatable.dart';

enum RoleScope {
  central,
  laboratory,
  branch,
  unknown;

  static RoleScope of(String name) => switch (name) {
    'super-admin' || 'team-member' => RoleScope.central,
    'laboratory-admin' => RoleScope.laboratory,
    'branch-manager' || 'doctor' || 'receptionist' => RoleScope.branch,
    _ => RoleScope.unknown,
  };

  bool get needsLaboratory =>
      this == RoleScope.laboratory || this == RoleScope.branch;

  bool get needsBranch => this == RoleScope.branch;
}

class RoleModel extends Equatable {
  const RoleModel({required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      RoleModel(name: json['name']?.toString() ?? '');

  final String name;

  RoleScope get scope => RoleScope.of(name);

  bool get isExclusive => name == 'team-member';

  @override
  List<Object?> get props => <Object?>[name];
}
