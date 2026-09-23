import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/models/lab_settings.dart';
import '../../../core/networking/api_constants.dart';

class SettingsRepo {
  const SettingsRepo(this._dio);

  final Dio _dio;

  Future<Result<LabSettings>> fetchSettings() {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.settingsList);
      return LabSettings.fromJson(response.data);
    });
  }
}
