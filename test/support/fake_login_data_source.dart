import 'package:dio/dio.dart';
import 'package:laboratory/login/data/datasources/login_remote_data_source.dart';
import 'package:laboratory/login/data/models/login_request_body.dart';
import 'package:laboratory/login/data/models/login_response.dart';

class FakeLoginDataSource implements LoginRemoteDataSource {
  FakeLoginDataSource();

  Object? error;

  LoginResponse? response;

  LoginRequestBody? lastBody;

  int callCount = 0;

  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    lastBody = body;
    callCount++;

    final Object? failure = error;
    if (failure != null) throw failure;

    return response ?? successResponse();
  }
}

LoginResponse successResponse({
  String name = 'Super Admin',
  String? tenantId,
  int? branchId,
}) {
  return LoginResponse.fromJson(<String, dynamic>{
    'user': <String, dynamic>{
      'id': 1,
      'name': name,
      'email': 'admin@email.com',
      'phones': <dynamic>[],
      'tenant_id': tenantId,
      'branch_id': branchId,
      'created_at': '2026-09-12T12:27:04.000000Z',
      'updated_at': '2026-09-12T12:27:04.000000Z',
    },
    'token': '4|CGM1BMtVdo2wD3lZq9SZOkhJU4W3uhyGh6L6EwAI3ea7f2eb',
    'token_type': 'Bearer',
  });
}

DioException httpFailure(
  int status,
  dynamic body, {
  Map<String, List<String>>? headers,
}) {
  final RequestOptions request = RequestOptions(path: 'auth/login');

  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: status,
      data: body,
      headers: Headers.fromMap(headers ?? <String, List<String>>{}),
    ),
  );
}

DioException networkFailure() => DioException(
  requestOptions: RequestOptions(path: 'auth/login'),
  type: DioExceptionType.connectionError,
);

const Map<String, dynamic> badCredentialsBody = <String, dynamic>{
  'message': 'These credentials do not match our records.',
  'errors': <String, dynamic>{
    'email': <String>['These credentials do not match our records.'],
  },
};

const Map<String, dynamic> unverifiedBody = <String, dynamic>{
  'message':
      'Your email address is not verified. Please verify your account to continue.',
  'errors': <String, dynamic>{
    'email': <String>[
      'Your email address is not verified. Please verify your account to continue.',
    ],
  },
};

const Map<String, dynamic> validationBody = <String, dynamic>{
  'message': 'The email field is required. (and 1 more error)',
  'errors': <String, dynamic>{
    'email': <String>['The email field is required.'],
    'password': <String>['The password field is required.'],
  },
};

const Map<String, dynamic> rateLimitedBody = <String, dynamic>{
  'data': <dynamic>[],
  'meta': <String, dynamic>{
    'message': 'Too Many Requests',
    'code': 429,
    'error': true,
    'validation_errors': <dynamic>[],
  },
};

const Map<String, dynamic> serverErrorBody = <String, dynamic>{
  'data': <dynamic>[],
  'meta': <String, dynamic>{
    'message': 'Internal Server Error',
    'code': 500,
    'error': true,
    'validation_errors': <dynamic>[],
  },
};
