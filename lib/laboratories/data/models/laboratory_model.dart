import 'package:equatable/equatable.dart';

class LaboratoryModel extends Equatable {
  const LaboratoryModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.branchesCount,
    this.admin,
  });

  final int id;
  final String name;
  final bool isActive;
  final int branchesCount;
  final String? admin;

  factory LaboratoryModel.fromJson(Map<String, dynamic> json) {
    return LaboratoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      isActive: json['is_active'] == true,
      branchesCount: (json['branches_count'] as num?)?.toInt() ?? 0,
      admin: json['admin']?.toString(),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    isActive,
    branchesCount,
    admin,
  ];
}
