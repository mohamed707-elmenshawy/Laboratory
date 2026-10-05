import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/units_page.dart';
import '../models/units_query.dart';
import '../models/unit_model.dart';
import '../models/unit_request_body.dart';

class UnitsRepo {
  final Dio _dio;

  const UnitsRepo(this._dio);

  Future<Result<UnitsPage>> fetchUnits(UnitsQuery query) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.units,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return UnitsPage.fromJson(data);
    });
  }

  Future<Result<UnitModel>> fetchUnit(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.units}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return UnitModel.fromJson(data);
    });
  }

  Future<Result<void>> createUnit(UnitRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.units, data: body.toJson());
    });
  }

  Future<Result<void>> updateUnit(int id, UnitRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post('${ApiConstants.units}/$id', data: body.toJson());
    });
  }

  Future<Result<void>> setUnitActive(int id, bool active) {
    return ErrorHandler.guard(() async {
      final String action = active ? 'activate' : 'deactivate';
      await _dio.patch('${ApiConstants.units}/$id/$action');
    });
  }

  Future<Result<void>> deleteUnit(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.units}/$id');
    });
  }
}
