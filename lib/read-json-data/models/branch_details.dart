import 'laboratory.dart';

class BranchDetails {
  final int id;
  final String name;
  final Laboratory laboratory;

  const BranchDetails({
    required this.id,
    required this.name,
    required this.laboratory,
  });

  factory BranchDetails.fromJson(Map<String, dynamic> json) {
    return BranchDetails(
      id: json['id'],
      name: json['name'],
      laboratory: Laboratory.fromJson(json['laboratory']),
    );
  }
}
