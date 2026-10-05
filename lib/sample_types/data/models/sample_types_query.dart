enum SampleTypeStatusFilter {
  all,
  active,
  inactive;

  bool? get isActive => switch (this) {
    SampleTypeStatusFilter.all => null,
    SampleTypeStatusFilter.active => true,
    SampleTypeStatusFilter.inactive => false,
  };
}

class SampleTypesQuery {
  const SampleTypesQuery({
    required this.page,
    required this.perPage,
    this.search = '',
    this.status = SampleTypeStatusFilter.all,
    this.laboratoryId,
    this.branchId,
  });

  final int page;
  final int perPage;
  final String search;
  final SampleTypeStatusFilter status;
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
