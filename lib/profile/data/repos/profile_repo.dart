import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../../../core/phones/phones.dart';
import '../models/profile_model.dart';
import '../models/update_profile_request_body.dart';

class ProfileRepo {
  final Dio _dio;

  const ProfileRepo(this._dio);

  Future<Result<ProfileModel>> fetchProfile() {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.profile);

      final Map<String, dynamic> data = response.data!['data'];
      return ProfileModel.fromJson(data);
    });
  }

  Future<Result<ProfileModel>> updateProfile(UpdateProfileRequestBody body) {
    return ErrorHandler.guard(() async {
      final response = await _dio.post(
        ApiConstants.updateProfile,
        data: body.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return ProfileModel.fromJson(data);
    });
  }

  Future<Result<List<PhoneTypeOption>>> fetchPhoneTypes() {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.phoneTypes);

      final List<dynamic> data = response.data!['data'] as List<dynamic>;
      return data
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) =>
                PhoneTypeOption.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    });
  }
}
