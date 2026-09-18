import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/change_password_request_body.dart';

class ChangePasswordRepo {
  final Dio _dio;

  const ChangePasswordRepo(this._dio);

  Future<Result<void>> changePassword(ChangePasswordRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.changePassword, data: body.toJson());
    });
  }
}
