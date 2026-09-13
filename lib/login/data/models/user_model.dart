class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.tenantId,
    required this.branchId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: _asInt(json['id']),
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    tenantId: json['tenant_id'] as String?,
    branchId: _asIntOrNull(json['branch_id']),
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
  );

  final int id;
  final String name;
  final String email;
  final String? tenantId;
  final int? branchId;
  final String? createdAt;
  final String? updatedAt;

  bool get isCentralAdmin => tenantId == null;

  bool get isBranchScoped => branchId != null;
}

int _asInt(Object? value) => _asIntOrNull(value) ?? 0;

int? _asIntOrNull(Object? value) => switch (value) {
  final int v => v,
  final num v => v.toInt(),
  final String v => int.tryParse(v),
  _ => null,
};
