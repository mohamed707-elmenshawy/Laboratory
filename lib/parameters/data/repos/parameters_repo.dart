import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/parameters_page.dart';
import '../models/parameters_query.dart';
import '../models/parameter_model.dart';
import '../models/parameter_request_body.dart';

class ParametersRepo {
  final Dio _dio;

  const ParametersRepo(this._dio);

  Future<Result<ParametersPage>> fetchParameters(ParametersQuery query) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.parameters,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return ParametersPage.fromJson(data);
    });
  }

  Future<Result<ParameterModel>> fetchParameter(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.parameters}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return ParameterModel.fromJson(data);
    });
  }

  Future<Result<void>> createParameter(ParameterRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.parameters, data: body.toJson());
    });
  }

  Future<Result<void>> updateParameter(int id, ParameterRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post('${ApiConstants.parameters}/$id', data: body.toJson());
    });
  }

  Future<Result<void>> setParameterActive(int id, bool active) {
    return ErrorHandler.guard(() async {
      final String action = active ? 'activate' : 'deactivate';
      await _dio.patch('${ApiConstants.parameters}/$id/$action');
    });
  }

  Future<Result<void>> deleteParameter(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.parameters}/$id');
    });
  }
}
