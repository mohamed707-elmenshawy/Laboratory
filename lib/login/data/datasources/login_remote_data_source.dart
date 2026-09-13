import 'package:dio/dio.dart';

import '../../../core/networking/api_constants.dart';
import '../models/login_request_body.dart';
import '../models/login_response.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponse> login(LoginRequestBody body);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  const LoginRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    final Response<dynamic> response = await _dio.post(
      ApiConstants.login,
      data: body.toJson(),
    );

    return LoginResponse.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map<dynamic, dynamic>),
    );
  }
}
