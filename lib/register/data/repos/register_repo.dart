import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/register_request_body.dart';
import '../models/register_response.dart';

class RegisterRepo {
  final Dio _dio;

  const RegisterRepo(this._dio);

  Future<Result<RegisterResponse>> register(RegisterRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.register, data: body.toJson());

      return RegisterResponse(email: body.email);
    });
  }
}
