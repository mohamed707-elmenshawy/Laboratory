import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/models/user_model.dart';
import '../../../core/networking/api_constants.dart';

class HomeRepo {
  final Dio _dio;

  const HomeRepo(this._dio);

  Future<Result<UserModel>> fetchProfile() {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.profile);

      final Map<String, dynamic> data = response.data!['data'];
      return UserModel.fromJson(data);
    });
  }

  Future<Result<void>> logout() {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.logout);
    });
  }
}
