class ParameterRequestBody {
  const ParameterRequestBody({
    required this.lang,
    required this.name,
    required this.description,
    required this.laboratoryId,
    required this.branchId,
  });

  final String lang;
  final String name;
  final String description;
  final int laboratoryId;
  final int branchId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lang': lang,
    'name': name,
    'description': description.isEmpty ? null : description,
    'laboratory_id': laboratoryId,
    'branch_id': branchId,
  };
}
