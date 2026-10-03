import 'package:equatable/equatable.dart';

import 'branch_model.dart';

class BranchesPagination extends Equatable {
  const BranchesPagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
  });

  factory BranchesPagination.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        (json['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return BranchesPagination(
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

class BranchesPage extends Equatable {
  final List<BranchModel> items;
  final BranchesPagination pagination;

  const BranchesPage({required this.items, required this.pagination});

  factory BranchesPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items =
        (json['items'] as List<dynamic>?) ?? <dynamic>[];

    return BranchesPage(
      items: items
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) =>
                BranchModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false),
      pagination: BranchesPagination.fromJson(
        (json['pagination'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  @override
  List<Object?> get props => <Object?>[items, pagination];
}
