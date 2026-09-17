import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/login_request_body.dart';
import '../models/login_response.dart';

class LoginRepo {
  final Dio _dio;

  const LoginRepo(this._dio);

  Future<Result<LoginResponse>> login(LoginRequestBody body) {
    return ErrorHandler.guard(() async {
      final response = await _dio.post(ApiConstants.login, data: body.toJson());

      final Map<String, dynamic> data = response.data!['data'];
      return LoginResponse.fromJson(data);
    });
  }
}
