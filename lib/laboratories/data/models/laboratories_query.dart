class LaboratoriesQuery {
  const LaboratoriesQuery({required this.page, required this.pageSize});

  final int page;
  final int pageSize;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'page': page,
    'page_size': pageSize,
  };
}
