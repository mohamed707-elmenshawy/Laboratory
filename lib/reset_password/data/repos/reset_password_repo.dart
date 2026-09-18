import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/reset_password_request_body.dart';

class ResetPasswordRepo {
  final Dio _dio;

  const ResetPasswordRepo(this._dio);

  Future<Result<void>> resetPassword(ResetPasswordRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.resetPassword, data: body.toJson());
    });
  }
}
