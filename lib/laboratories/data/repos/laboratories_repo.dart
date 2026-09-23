import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/laboratories_page.dart';
import '../models/laboratories_query.dart';

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
}
