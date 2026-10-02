import 'package:equatable/equatable.dart';

class LaboratoryMenuItem extends Equatable {
  const LaboratoryMenuItem({required this.id, required this.name});

  factory LaboratoryMenuItem.fromJson(Map<String, dynamic> json) =>
      LaboratoryMenuItem(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
      );

  final int id;
  final String name;

  @override
  List<Object?> get props => <Object?>[id, name];
}
