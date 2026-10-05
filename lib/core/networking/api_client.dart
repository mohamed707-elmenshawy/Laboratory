import 'package:dio/dio.dart';

import 'api_error_mapper.dart';

/// The only class repositories talk to for HTTP.
///
/// It returns the decoded response body and throws an [AppError] on failure,
/// so no `DioException` ever reaches a repository. Parsing the body into a
/// model, and turning a throw into a `Result`, stay the repository's job
/// (see `guard`).
class ApiClient {
  /// A [mapper] with another `parseBody` adapts this to a backend that does
  /// not answer errors with the Laravel envelope.
  ApiClient(this._dio, {ApiErrorMapper mapper = const ApiErrorMapper()})
    : _mapper = mapper;

  final Dio _dio;
  final ApiErrorMapper _mapper;

  Future<Object?> get(String path, {Map<String, dynamic>? query}) =>
      _request(() => _dio.get<Object?>(path, queryParameters: query));

  Future<Object?> post(String path, {Object? data}) =>
      _request(() => _dio.post<Object?>(path, data: data));

  Future<Object?> put(String path, {Object? data}) =>
      _request(() => _dio.put<Object?>(path, data: data));

  Future<Object?> patch(String path, {Object? data}) =>
      _request(() => _dio.patch<Object?>(path, data: data));

  Future<Object?> delete(String path, {Object? data}) =>
      _request(() => _dio.delete<Object?>(path, data: data));

  Future<Object?> _request(Future<Response<Object?>> Function() send) async =>
      (await _mapper.translate(send)).data;
}
