enum BranchStatusFilter {
  all,
  active,
  inactive;

  bool? get isActive => switch (this) {
    BranchStatusFilter.all => null,
    BranchStatusFilter.active => true,
    BranchStatusFilter.inactive => false,
  };
}

class BranchesQuery {
  const BranchesQuery({
    required this.page,
    required this.perPage,
    this.search = '',
    this.status = BranchStatusFilter.all,
    this.laboratoryId,
  });

  final int page;
  final int perPage;
  final String search;
  final BranchStatusFilter status;
  final int? laboratoryId;

  Map<String, dynamic> toJson() {
    final bool? isActive = status.isActive;

    return <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive ? 1 : 0,
      if (laboratoryId != null) 'laboratory_id': laboratoryId,
    };
  }
}
