// ignore_for_file: public_member_api_docs, sort_constructors_first
class LaboratorytResponse {
  List<Items> items;

  // PaginationLinks paginationLinks;

  LaboratorytResponse({required this.items});

  factory LaboratorytResponse.fromJson(Map<String, dynamic> json) {
    return LaboratorytResponse(
      items: (json['data']['items'] as List)
          .map((element) => Items.fromJson(element))
          .toList(),

      // paginationLinks: PaginationLinks.fromJson(json['pagination']),
    );
  }
}

class Items {
  final int id;
  final String name;

  Items({required this.id, required this.name});

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(id: json['id'] as int, name: json['name'] as String);
  }
}

// class PaginationLinks {
//   final String firstPageUrl;
//   final String lastPageUrl;
//   final String? prevPageUrl;
//   final String? nextPageUrl;

//   const PaginationLinks({
//     required this.firstPageUrl,
//     required this.lastPageUrl,
//     this.prevPageUrl,
//     this.nextPageUrl,
//   });

//   factory PaginationLinks.fromJson(Map<String, dynamic> json) {
//     return PaginationLinks(
//       firstPageUrl: json['first_page_url'] as String,
//       lastPageUrl: json['last_page_url'] as String,
//       prevPageUrl: json['prev_page_url'] as String?,
//       nextPageUrl: json['next_page_url'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'first_page_url': firstPageUrl,
//       'last_page_url': lastPageUrl,
//       'prev_page_url': prevPageUrl,
//       'next_page_url': nextPageUrl,
//     };
//   }
// }
