class UsersQuery {
  const UsersQuery({
    required this.page,
    required this.perPage,
    this.search = '',
    this.laboratoryId,
    this.branchId,
  });

  final int page;
  final int perPage;
  final String search;
  final int? laboratoryId;
  final int? branchId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'per_page': perPage,
    if (search.isNotEmpty) 'search': search,
    if (laboratoryId != null) 'laboratory_id': laboratoryId,
    if (branchId != null) 'branch_id': branchId,
  };
}
