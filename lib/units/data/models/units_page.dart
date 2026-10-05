import 'package:equatable/equatable.dart';

import 'unit_model.dart';

class UnitsPagination extends Equatable {
  const UnitsPagination({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    this.from,
    this.to,
  });

  factory UnitsPagination.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        (json['meta'] as Map<String, dynamic>?) ?? <String, dynamic>{};

    return UnitsPagination(
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

class UnitsPage extends Equatable {
  const UnitsPage({required this.items, required this.pagination});

  factory UnitsPage.fromJson(Map<String, dynamic> json) {
    final List<dynamic> items =
        (json['items'] as List<dynamic>?) ?? <dynamic>[];

    return UnitsPage(
      items: items
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) =>
                UnitModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false),
      pagination: UnitsPagination.fromJson(
        (json['pagination'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  final List<UnitModel> items;
  final UnitsPagination pagination;

  @override
  List<Object?> get props => <Object?>[items, pagination];
}
