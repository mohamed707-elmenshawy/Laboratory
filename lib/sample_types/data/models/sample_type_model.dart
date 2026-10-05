import 'package:equatable/equatable.dart';

import '../../../core/models/named_ref.dart';

class SampleTypeModel extends Equatable {
  final int id;
  final String name;
  final bool isActive;
  final String? description;
  final NamedRef? laboratory;
  final NamedRef? branch;

  const SampleTypeModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.description,
    this.laboratory,
    this.branch,
  });

  factory SampleTypeModel.fromJson(Map<String, dynamic> json) =>
      SampleTypeModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
        isActive: json['is_active'] == true,
        description: json['description']?.toString(),
        laboratory: NamedRef.maybeFrom(json['laboratory']),
        branch: NamedRef.maybeFrom(json['branch']),
      );

  SampleTypeModel withActive(bool active) => SampleTypeModel(
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
