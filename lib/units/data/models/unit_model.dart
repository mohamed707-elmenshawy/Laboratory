import 'package:equatable/equatable.dart';

import '../../../core/models/named_ref.dart';

class UnitModel extends Equatable {
  final int id;
  final String name;
  final String symbol;
  final bool isActive;
  final String? description;
  final NamedRef? laboratory;
  final NamedRef? branch;

  const UnitModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isActive,
    this.description,
    this.laboratory,
    this.branch,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
    symbol: json['symbol']?.toString() ?? '',
    isActive: json['is_active'] == true,
    description: json['description']?.toString(),
    laboratory: NamedRef.maybeFrom(json['laboratory']),
    branch: NamedRef.maybeFrom(json['branch']),
  );

  UnitModel withActive(bool active) => UnitModel(
    id: id,
    name: name,
    symbol: symbol,
    isActive: active,
    description: description,
    laboratory: laboratory,
    branch: branch,
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    symbol,
    isActive,
    description,
    laboratory,
    branch,
  ];
}
