enum LaboratoryStatusFilter {
  all,
  active,
  inactive;

  bool? get isActive => switch (this) {
    LaboratoryStatusFilter.all => null,
    LaboratoryStatusFilter.active => true,
    LaboratoryStatusFilter.inactive => false,
  };
}

class LaboratoriesQuery {
  const LaboratoriesQuery({
    required this.page,
    required this.pageSize,
    this.search = '',
    this.status = LaboratoryStatusFilter.all,
  });

  final int page;
  final int pageSize;
  final String search;
  final LaboratoryStatusFilter status;

  Map<String, dynamic> toJson() {
    final bool? isActive = status.isActive;

    return <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (search.isNotEmpty) 'search': search,
      if (isActive != null) 'is_active': isActive ? 1 : 0,
    };
  }
}
