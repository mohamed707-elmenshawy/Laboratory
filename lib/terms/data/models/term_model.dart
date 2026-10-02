import 'package:equatable/equatable.dart';

class TermModel extends Equatable {
  const TermModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  final int id;
  final String name;
  final String description;
  final bool isActive;

  factory TermModel.fromJson(Map<String, dynamic> json) {
    return TermModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isActive: json['is_active'] != false,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, description, isActive];
}
