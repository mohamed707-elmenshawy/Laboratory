import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/verification_request_body.dart';
import '../models/verification_response.dart';

class VerificationRepo {
  final Dio _dio;

  const VerificationRepo(this._dio);

  Future<Result<VerificationResponse>> verify(VerificationRequestBody body) {
    return ErrorHandler.guard(() async {
      final response = await _dio.post(ApiConstants.verify, data: body.toJson());

      final Map<String, dynamic> data = response.data!['data'];
      return VerificationResponse.fromJson(data);
    });
  }
}
