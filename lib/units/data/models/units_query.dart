enum UnitStatusFilter {
  all,
  active,
  inactive;

  bool? get isActive => switch (this) {
    UnitStatusFilter.all => null,
    UnitStatusFilter.active => true,
    UnitStatusFilter.inactive => false,
  };
}

class UnitsQuery {
  const UnitsQuery({
    required this.page,
    required this.perPage,
    this.search = '',
    this.status = UnitStatusFilter.all,
    this.laboratoryId,
    this.branchId,
  });

  final int page;
  final int perPage;
  final String search;
  final UnitStatusFilter status;
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
