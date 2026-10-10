import 'package:equatable/equatable.dart';

class BranchMenuItem extends Equatable {
  const BranchMenuItem({required this.id, required this.name});

  factory BranchMenuItem.fromJson(Map<String, dynamic> json) => BranchMenuItem(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name']?.toString() ?? '',
  );

  final int id;
  final String name;

  @override
  List<Object?> get props => <Object?>[id, name];
}
