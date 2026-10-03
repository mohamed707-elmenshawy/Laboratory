import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/test_categories_page.dart';
import '../models/test_categories_query.dart';
import '../models/test_category_model.dart';
import '../models/test_category_request_body.dart';

class TestCategoriesRepo {
  final Dio _dio;

  const TestCategoriesRepo(this._dio);

  Future<Result<TestCategoriesPage>> fetchTestCategories(
    TestCategoriesQuery query,
  ) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.testCategories,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return TestCategoriesPage.fromJson(data);
    });
  }

  Future<Result<TestCategoryModel>> fetchTestCategory(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.testCategories}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return TestCategoryModel.fromJson(data);
    });
  }

  Future<Result<void>> createTestCategory(TestCategoryRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.testCategories, data: body.toJson());
    });
  }

  Future<Result<void>> updateTestCategory(
    int id,
    TestCategoryRequestBody body,
  ) {
    return ErrorHandler.guard(() async {
      await _dio.post(
        '${ApiConstants.testCategories}/$id',
        data: body.toJson(),
      );
    });
  }

  Future<Result<void>> setTestCategoryActive(int id, bool active) {
    return ErrorHandler.guard(() async {
      final String action = active ? 'activate' : 'deactivate';
      await _dio.patch('${ApiConstants.testCategories}/$id/$action');
    });
  }

  Future<Result<void>> deleteTestCategory(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.testCategories}/$id');
    });
  }
}
