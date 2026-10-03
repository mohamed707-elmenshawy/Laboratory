import 'package:dio/dio.dart';
import 'package:laboratory/core/error/error_handler.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/networking/api_constants.dart';
import 'package:laboratory/test/data/models/test_category_model.dart';

class TestCategoryRepo {
  final Dio _dio;
  TestCategoryRepo(this._dio);

  Future<Result<TestCategoryModel>> testCategoryRepo() async {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.testCategory);
      TestCategoryModel testCategoryModel = TestCategoryModel.fromJson(
        response.data,
      );
      print(testCategoryModel.data.items.length);
      return testCategoryModel;
    });
  }
}
// final Map<String, dynamic> json = Map<String, dynamic>.from(
//   response.data as Map,
// );
// return TestCategoryModel.fromJson(json);
