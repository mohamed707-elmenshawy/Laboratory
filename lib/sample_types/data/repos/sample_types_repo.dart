import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/sample_types_page.dart';
import '../models/sample_types_query.dart';
import '../models/sample_type_model.dart';
import '../models/sample_type_request_body.dart';

class SampleTypesRepo {
  final Dio _dio;

  const SampleTypesRepo(this._dio);

  Future<Result<SampleTypesPage>> fetchSampleTypes(SampleTypesQuery query) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.sampleTypes,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return SampleTypesPage.fromJson(data);
    });
  }

  Future<Result<SampleTypeModel>> fetchSampleType(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.sampleTypes}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return SampleTypeModel.fromJson(data);
    });
  }

  Future<Result<void>> createSampleType(SampleTypeRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.sampleTypes, data: body.toJson());
    });
  }

  Future<Result<void>> updateSampleType(int id, SampleTypeRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post('${ApiConstants.sampleTypes}/$id', data: body.toJson());
    });
  }

  Future<Result<void>> setSampleTypeActive(int id, bool active) {
    return ErrorHandler.guard(() async {
      final String action = active ? 'activate' : 'deactivate';
      await _dio.patch('${ApiConstants.sampleTypes}/$id/$action');
    });
  }

  Future<Result<void>> deleteSampleType(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.sampleTypes}/$id');
    });
  }
}
