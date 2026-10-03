enum TestCategoryStatusFilter {
  all,
  active,
  inactive;

  bool? get isActive => switch (this) {
    TestCategoryStatusFilter.all => null,
    TestCategoryStatusFilter.active => true,
    TestCategoryStatusFilter.inactive => false,
  };
}

class TestCategoriesQuery {
  const TestCategoriesQuery({
    required this.page,
    required this.perPage,
    this.search = '',
    this.status = TestCategoryStatusFilter.all,
    this.laboratoryId,
    this.branchId,
  });

  final int page;
  final int perPage;
  final String search;
  final TestCategoryStatusFilter status;
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
