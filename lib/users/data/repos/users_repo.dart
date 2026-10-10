import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/role_model.dart';
import '../models/user_model.dart';
import '../models/user_request_body.dart';
import '../models/users_page.dart';
import '../models/users_query.dart';

class UsersRepo {
  final Dio _dio;

  const UsersRepo(this._dio);

  Future<Result<UsersPage>> fetchUsers(UsersQuery query) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.users,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return UsersPage.fromJson(data);
    });
  }

  Future<Result<UserModel>> fetchUser(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.users}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return UserModel.fromJson(data);
    });
  }

  Future<Result<void>> createUser(UserRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.users, data: body.toJson());
    });
  }

  Future<Result<void>> updateUser(int id, UserRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post('${ApiConstants.users}/$id', data: body.toJson());
    });
  }

  Future<Result<void>> deleteUser(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.users}/$id');
    });
  }

  Future<Result<List<RoleModel>>> fetchRoles() {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.roles);

      final List<dynamic> data = response.data!['data'] as List<dynamic>;

      return data
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> role) =>
                RoleModel.fromJson(Map<String, dynamic>.from(role)),
          )
          .toList(growable: false);
    });
  }
}
