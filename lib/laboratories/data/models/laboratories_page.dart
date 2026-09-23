import 'package:equatable/equatable.dart';

import 'laboratory_model.dart';

class LaboratoriesPagination extends Equatable {
  const LaboratoriesPagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
  });

  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int? from;
  final int? to;

  bool get hasPrevious => currentPage > 1;
  bool get hasNext => currentPage < lastPage;

  factory LaboratoriesPagination.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        (json['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return LaboratoriesPagination(
      total: (meta['total'] as num?)?.toInt() ?? 0,
      perPage: (meta['per_page'] as num?)?.toInt() ?? 0,
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      from: (meta['from'] as num?)?.toInt(),
      to: (meta['to'] as num?)?.toInt(),
    );
  }

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

class LaboratoriesPage extends Equatable {
  const LaboratoriesPage({required this.items, required this.pagination});

  final List<LaboratoryModel> items;
  final LaboratoriesPagination pagination;

  factory LaboratoriesPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items = (json['items'] as List<dynamic>?) ?? <dynamic>[];

    return LaboratoriesPage(
      items: items
          .map(
            (dynamic item) =>
                LaboratoryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      pagination: LaboratoriesPagination.fromJson(
        (json['pagination'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  @override
  List<Object?> get props => <Object?>[items, pagination];
}
