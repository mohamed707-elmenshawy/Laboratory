class TestCategory {
  final int id;
  final String name;
  final int testsCount;

  const TestCategory({
    required this.id,
    required this.name,
    required this.testsCount,
  });

  factory TestCategory.fromJson(Map<String, dynamic> json) {
    return TestCategory(
      id: json['id'],
      name: json['name'],
      testsCount: json['tests_count'],
    );
  }
}
