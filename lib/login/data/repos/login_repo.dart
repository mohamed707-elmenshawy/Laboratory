import '../datasources/login_remote_data_source.dart';
import '../models/login_request_body.dart';
import '../models/login_response.dart';

class LoginRepo {
  const LoginRepo(this._remoteDataSource);

  final LoginRemoteDataSource _remoteDataSource;

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.login(
      LoginRequestBody(email: email.trim(), password: password),
    );
  }
}
