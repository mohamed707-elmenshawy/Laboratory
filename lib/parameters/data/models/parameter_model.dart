import 'package:equatable/equatable.dart';

import '../../../core/models/named_ref.dart';

class ParameterModel extends Equatable {
  final int id;
  final String name;
  final bool isActive;
  final String? description;
  final NamedRef? laboratory;
  final NamedRef? branch;

  const ParameterModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.description,
    this.laboratory,
    this.branch,
  });

  factory ParameterModel.fromJson(Map<String, dynamic> json) => ParameterModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    isActive: json['is_active'] == true,
    description: json['description']?.toString(),
    laboratory: NamedRef.maybeFrom(json['laboratory']),
    branch: NamedRef.maybeFrom(json['branch']),
  );

  ParameterModel withActive(bool active) => ParameterModel(
    id: id,
    name: name,
    isActive: active,
    description: description,
    laboratory: laboratory,
    branch: branch,
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    isActive,
    description,
    laboratory,
    branch,
  ];
}
