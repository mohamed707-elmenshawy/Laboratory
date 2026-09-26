import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/create_laboratory_request_body.dart';
import '../models/laboratories_page.dart';
import '../models/laboratories_query.dart';
import '../models/laboratory_model.dart';

class LaboratoriesRepo {
  final Dio _dio;

  const LaboratoriesRepo(this._dio);

  Future<Result<LaboratoriesPage>> fetchLaboratories(LaboratoriesQuery query) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.laboratories,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return LaboratoriesPage.fromJson(data);
    });
  }

  Future<Result<void>> createLaboratory(CreateLaboratoryRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.laboratories, data: body.toJson());
    });
  }

  Future<Result<LaboratoryModel>> fetchLaboratory(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.laboratories}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return LaboratoryModel.fromJson(data);
    });
  }

  Future<Result<LaboratoryModel>> setLaboratoryActive(int id, bool active) {
    return ErrorHandler.guard(() async {
      final String action = active ? 'activate' : 'deactivate';
      final response = await _dio.patch(
        '${ApiConstants.laboratories}/$id/$action',
      );

      final Map<String, dynamic> data = response.data!['data'];
      return LaboratoryModel.fromJson(data);
    });
  }

  Future<Result<void>> deleteLaboratory(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.laboratories}/$id');
    });
  }
}
