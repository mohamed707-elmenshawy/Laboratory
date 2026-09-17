import 'test_category.dart';

class TestCategoriesResponse {
  final List<TestCategory> categories;
  final String message;

  const TestCategoriesResponse({
    required this.categories,
    required this.message,
  });

  factory TestCategoriesResponse.fromJson(Map<String, dynamic> jsonData) {
    return TestCategoriesResponse(
      categories: (jsonData['data'] as List)
          .map((json) => TestCategory.fromJson(json))
          .toList(),
      message: jsonData['meta']['message'],
    );
  }
}
