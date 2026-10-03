//parsing data
class TestCategoryModel {
  Data data;
  Meta meta;
  TestCategoryModel({required this.data, required this.meta});
  factory TestCategoryModel.fromJson(Map<String, dynamic> jsonData) {
    //mapping data
    return TestCategoryModel(
      data: Data.fromJson(jsonData['data']),
      meta: Meta.fromJson(jsonData['meta']),
    );
  }
}

class Data {
  List<Items> items;
  Pagination pagination;

  Data({required this.items, required this.pagination});
  factory Data.fromJson(Map<String, dynamic> jsonData) {
    return Data(
      items: (jsonData['items'] as List).map((element) {
        return Items.fromJson(element as Map<String, dynamic>);
      }).toList(),
      pagination: Pagination.fromJson(jsonData['pagination']),
    );
  }
}

class Pagination {
  final PaginationLinksModel links;
  final PaginationMetaModel meta;
  Pagination({required this.links, required this.meta});
  factory Pagination.fromJson(Map<String, dynamic> jsonData) {
    return Pagination(
      links: PaginationLinksModel.fromJson(jsonData['links']),
      meta: PaginationMetaModel.fromJson(jsonData['meta']),
    );
  }
}

class Items {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final dynamic branch;
  final dynamic laboratory;
  Items({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    this.branch,
    this.laboratory,
  });
  factory Items.fromJson(Map<String, dynamic> jsonData) {
    return Items(
      id: jsonData['id'] as int,
      name: jsonData['name'] as String,
      description: jsonData['description'] as String,
      isActive: jsonData['is_active'] as bool,
      branch: jsonData['branch'],
      laboratory: jsonData['laboratory'],
    );
  }
}

class Meta {
  final String message;
  final int code;
  final bool error;
  final List<dynamic> validationErrors;

  Meta({
    required this.message,
    required this.code,
    required this.error,
    required this.validationErrors,
  });

  factory Meta.fromJson(Map<String, dynamic> jsonData) {
    return Meta(
      message: jsonData['message'],
      code: jsonData['code'],
      error: jsonData['error'],
      validationErrors: jsonData['validation_errors'] ?? [],
    );
  }
}

class PaginationLinksModel {
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? prevPageUrl;
  final String? nextPageUrl;

  PaginationLinksModel({
    this.firstPageUrl,
    this.lastPageUrl,
    this.prevPageUrl,
    this.nextPageUrl,
  });

  factory PaginationLinksModel.fromJson(Map<String, dynamic> json) {
    return PaginationLinksModel(
      firstPageUrl: json['first_page_url'] as String?,
      lastPageUrl: json['last_page_url'] as String?,
      prevPageUrl: json['prev_page_url'] as String?,
      nextPageUrl: json['next_page_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_page_url': firstPageUrl,
      'last_page_url': lastPageUrl,
      'prev_page_url': prevPageUrl,
      'next_page_url': nextPageUrl,
    };
  }
}

class PaginationMetaModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;

  PaginationMetaModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      from: json['from'] as int,
      to: json['to'] as int,
    );
  }
}
