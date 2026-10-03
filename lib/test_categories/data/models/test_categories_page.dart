import 'package:equatable/equatable.dart';

import 'test_category_model.dart';

class TestCategoriesPagination extends Equatable {
  const TestCategoriesPagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
  });

  factory TestCategoriesPagination.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        (json['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return TestCategoriesPagination(
      total: (meta['total'] as num?)?.toInt() ?? 0,
      perPage: (meta['per_page'] as num?)?.toInt() ?? 0,
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      from: (meta['from'] as num?)?.toInt(),
      to: (meta['to'] as num?)?.toInt(),
    );
  }

  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int? from;
  final int? to;

  bool get hasPrevious => currentPage > 1;
  bool get hasNext => currentPage < lastPage;

  @override
  List<Object?> get props => <Object?>[
    total,
    perPage,
    currentPage,
    lastPage,
    from,
    to,
  ];
}

class TestCategoriesPage extends Equatable {
  const TestCategoriesPage({required this.items, required this.pagination});

  factory TestCategoriesPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items =
        (json['items'] as List<dynamic>?) ?? <dynamic>[];

    return TestCategoriesPage(
      items: items
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) =>
                TestCategoryModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false),
      pagination: TestCategoriesPagination.fromJson(
        (json['pagination'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  final List<TestCategoryModel> items;
  final TestCategoriesPagination pagination;

  @override
  List<Object?> get props => <Object?>[items, pagination];
}
