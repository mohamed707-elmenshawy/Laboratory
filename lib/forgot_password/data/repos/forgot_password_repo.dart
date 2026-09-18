import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/forgot_password_request_body.dart';

class ForgotPasswordRepo {
  final Dio _dio;

  const ForgotPasswordRepo(this._dio);

  Future<Result<void>> sendResetLink(ForgotPasswordRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.forgotPassword, data: body.toJson());
    });
  }
}
