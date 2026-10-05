import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:laboratory/core/networking/api_client.dart';
import 'package:laboratory/core/networking/api_error_mapper.dart';

typedef StubHandler = Future<ResponseBody> Function(RequestOptions options);

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this._handler);

  final StubHandler _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => _handler(options);

  @override
  void close({bool force = false}) {}
}

/// A real [ApiClient] over a [Dio] that never touches the network.
ApiClient stubApiClient(
  StubHandler handler, {
  ApiErrorMapper mapper = const ApiErrorMapper(),
}) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://example.test/api/v1/',
      validateStatus: (int? status) =>
          status != null && status >= 200 && status < 300,
    ),
  )..httpClientAdapter = _StubAdapter(handler);

  return ApiClient(dio, mapper: mapper);
}

/// A JSON response with [status].
Future<ResponseBody> jsonResponse(
  String body, {
  int status = 200,
  Map<String, List<String>> headers = const <String, List<String>>{},
}) async => ResponseBody.fromString(
  body,
  status,
  headers: <String, List<String>>{
    Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    ...headers,
  },
);

/// A request that fails before any response, like a dropped connection.
Future<ResponseBody> transportFailure(
  RequestOptions options,
  DioExceptionType type, {
  StackTrace? stackTrace,
}) => Future<ResponseBody>.error(
  DioException(requestOptions: options, type: type, stackTrace: stackTrace),
);
