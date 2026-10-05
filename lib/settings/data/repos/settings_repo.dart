import '../../../core/error/guard.dart';
import '../../../core/error/result.dart';
import '../../../core/models/lab_settings.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/networking/api_constants.dart';

class SettingsRepo {
  const SettingsRepo(this._api);

  final ApiClient _api;

  Future<Result<LabSettings>> fetchSettings() {
    return guard(() async {
      var response = LabSettings.fromJson(
        await _api.get(ApiConstants.settingsList),
      );
      return response;
    });
  }
}
