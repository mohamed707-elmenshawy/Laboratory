import 'package:equatable/equatable.dart';

import '../../../core/phones/phones.dart';

class BranchLaboratory extends Equatable {
  const BranchLaboratory({required this.id, required this.name});

  factory BranchLaboratory.fromJson(Map<String, dynamic> json) =>
      BranchLaboratory(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
      );

  final int id;
  final String name;

  @override
  List<Object?> get props => <Object?>[id, name];
}

class BranchModel extends Equatable {
  const BranchModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isMainBranch,
    this.address,
    this.laboratory,
    this.manager,
    this.phones = const <PhoneModel>[],
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    isActive: json['is_active'] == true,
    isMainBranch: json['is_main_branch'] == true,
    address: json['address']?.toString(),
    laboratory: switch (json['laboratory']) {
      final Map<dynamic, dynamic> laboratory => BranchLaboratory.fromJson(
        Map<String, dynamic>.from(laboratory),
      ),
      _ => null,
    },
    manager: json['manager']?.toString(),
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
  final bool isActive;
  final bool isMainBranch;
  final String? address;
  final BranchLaboratory? laboratory;
  final String? manager;
  final List<PhoneModel> phones;

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    isActive,
    isMainBranch,
    address,
    laboratory,
    manager,
    phones,
  ];
}
