enum ParameterStatusFilter {
  all,
  active,
  inactive;

  bool? get isActive => switch (this) {
    ParameterStatusFilter.all => null,
    ParameterStatusFilter.active => true,
    ParameterStatusFilter.inactive => false,
  };
}

class ParametersQuery {
  const ParametersQuery({
    required this.page,
    required this.perPage,
    this.search = '',
    this.status = ParameterStatusFilter.all,
    this.laboratoryId,
    this.branchId,
  });

  final int page;
  final int perPage;
  final String search;
  final ParameterStatusFilter status;
  final int? laboratoryId;
  final int? branchId;

  Map<String, dynamic> toJson() {
    final bool? isActive = status.isActive;

    return <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive ? 1 : 0,
      if (laboratoryId != null) 'laboratory_id': laboratoryId,
      if (branchId != null) 'branch_id': branchId,
    };
  }
}
