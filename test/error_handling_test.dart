import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/error_handler.dart';
import 'package:laboratory/core/error/guard.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/networking/api_client.dart';
import 'package:laboratory/core/networking/api_error_mapper.dart';

import 'support/capture_reports.dart';
import 'support/stub_api.dart';

void main() {
  final List<Report> reports = captureReports();
  final StackTrace marker = StackTrace.fromString('#0 MARKER_FRAME (marker)');

  Future<AppError> failureOf(
    ApiClient client,
    Future<Object?> Function(ApiClient client) call,
  ) async {
    final Result<Object?> result = await guard(() => call(client));
    expect(result, isA<Failure<Object?>>());
    return (result as Failure<Object?>).error;
  }

  DioException dioError(
    DioExceptionType type, {
    Response<dynamic>? response,
    Object? error,
    StackTrace? stackTrace,
  }) => DioException(
    requestOptions: RequestOptions(path: 'x'),
    type: type,
    response: response,
    error: error,
    stackTrace: stackTrace,
  );

  Response<dynamic> responseOf(
    int status,
    Object? data, {
    Map<String, List<String>> headers = const <String, List<String>>{},
  }) => Response<dynamic>(
    requestOptions: RequestOptions(path: 'x'),
    statusCode: status,
    data: data,
    headers: Headers.fromMap(headers),
  );

  group('ApiClient requests', () {
    test('returns the decoded body on success', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse('{"data":{"id":1}}'),
      );

      expect(await client.get('things'), <String, dynamic>{
        'data': <String, dynamic>{'id': 1},
      });
    });

    test('sends each verb with its path, query and body', () async {
      final List<RequestOptions> seen = <RequestOptions>[];
      final ApiClient client = stubApiClient((RequestOptions options) {
        seen.add(options);
        return jsonResponse('{}');
      });
      final FormData form = FormData.fromMap(<String, dynamic>{'a': 'b'});

      await client.get('things', query: <String, dynamic>{'page': 2});
      await client.post('things', data: <String, dynamic>{'n': 1});
      await client.put('things/1', data: <String, dynamic>{'n': 2});
      await client.patch('things/1/activate');
      await client.delete('things/1');
      await client.post('things/upload', data: form);

      expect(seen.map((RequestOptions o) => '${o.method} ${o.path}'), <String>[
        'GET things',
        'POST things',
        'PUT things/1',
        'PATCH things/1/activate',
        'DELETE things/1',
        'POST things/upload',
      ]);
      expect(seen[0].queryParameters, <String, dynamic>{'page': 2});
      expect(seen[1].data, <String, dynamic>{'n': 1});
      expect(seen[2].data, <String, dynamic>{'n': 2});
      expect(seen[3].data, isNull);
      expect(seen[5].data, same(form));
    });
  });

  group('ApiClient errors', () {
    test('maps a 422 to validation with field messages', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse(
          '{"message":"Invalid","errors":{"email":["Taken","Bad"]}}',
          status: 422,
        ),
      );

      final AppError error = await failureOf(client, (c) => c.post('things'));

      expect(error.kind, AppErrorKind.validation);
      expect(error.statusCode, 422);
      expect(error.message, 'Invalid');
      expect(error.fieldError('email'), 'Taken');
    });

    test('reads the message and fields from the meta envelope', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse(
          '{"data":[],"meta":{"message":"Nope","validation_errors":'
          '{"name":"Required"}}}',
          status: 422,
        ),
      );

      final AppError error = await failureOf(client, (c) => c.post('things'));

      expect(error.message, 'Nope');
      expect(error.fieldError('name'), 'Required');
    });

    test('maps status codes to kinds', () async {
      const Map<int, AppErrorKind> expected = <int, AppErrorKind>{
        400: AppErrorKind.badRequest,
        401: AppErrorKind.unauthorized,
        403: AppErrorKind.forbidden,
        404: AppErrorKind.notFound,
        429: AppErrorKind.rateLimited,
        500: AppErrorKind.server,
        503: AppErrorKind.server,
        418: AppErrorKind.unknown,
      };

      for (final MapEntry<int, AppErrorKind> entry in expected.entries) {
        final ApiClient client = stubApiClient(
          (_) => jsonResponse('{}', status: entry.key),
        );

        final AppError error = await failureOf(client, (c) => c.get('x'));

        expect(error.kind, entry.value, reason: 'status ${entry.key}');
        expect(error.statusCode, entry.key);
      }
    });

    test('reads Retry-After on a 429', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse(
          '{}',
          status: 429,
          headers: const <String, List<String>>{
            'retry-after': <String>['7'],
          },
        ),
      );

      final AppError error = await failureOf(client, (c) => c.get('x'));

      expect(error.retryAfter, const Duration(seconds: 7));
    });

    test('maps transport failures without reporting them', () async {
      const Map<DioExceptionType, AppErrorKind> expected =
          <DioExceptionType, AppErrorKind>{
            DioExceptionType.connectionTimeout: AppErrorKind.timeout,
            DioExceptionType.sendTimeout: AppErrorKind.timeout,
            DioExceptionType.receiveTimeout: AppErrorKind.timeout,
            DioExceptionType.connectionError: AppErrorKind.network,
            DioExceptionType.badCertificate: AppErrorKind.network,
            DioExceptionType.cancel: AppErrorKind.cancelled,
            DioExceptionType.unknown: AppErrorKind.network,
          };

      for (final MapEntry<DioExceptionType, AppErrorKind> entry
          in expected.entries) {
        final ApiClient client = stubApiClient(
          (RequestOptions options) => transportFailure(options, entry.key),
        );

        final AppError error = await failureOf(client, (c) => c.get('x'));

        expect(error.kind, entry.value, reason: entry.key.name);
      }
      expect(reports, isEmpty);
    });

    test('a body that is not JSON is a reported parsing error', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse('<html>oops</html>'),
      );

      final AppError error = await failureOf(client, (c) => c.get('x'));

      expect(error.kind, AppErrorKind.parsing);
      expect(reports.single.error, isA<FormatException>());
    });

    test('keeps the stack trace of the failed request', () async {
      final ApiClient client = stubApiClient(
        (RequestOptions options) => transportFailure(
          options,
          DioExceptionType.connectionTimeout,
          stackTrace: marker,
        ),
      );

      try {
        await client.get('x');
        fail('should have thrown');
      } on AppError catch (_, stackTrace) {
        expect(stackTrace.toString(), contains('MARKER_FRAME'));
      }
    });

    test('a custom body parser adapts the error to another backend', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse('{"detail":"Out of stock"}', status: 409),
        mapper: ApiErrorMapper(
          parseBody: (Object? data) =>
              ApiErrorBody(message: (data as Map<dynamic, dynamic>)['detail']),
        ),
      );

      final AppError error = await failureOf(client, (c) => c.get('x'));

      expect(error.message, 'Out of stock');
      expect(error.statusCode, 409);
    });
  });

  group('guard', () {
    test('wraps a value in Success', () async {
      final Result<int> result = await guard(() async => 3);

      expect((result as Success<int>).data, 3);
    });

    test('passes an AppError through without reporting it', () async {
      const AppError thrown = AppError(kind: AppErrorKind.forbidden);

      final Result<int> result = await guard<int>(() => throw thrown);

      expect((result as Failure<int>).error, thrown);
      expect(reports, isEmpty);
    });

    test('reports the cause an AppError carries', () async {
      final FormatException cause = const FormatException('bad body');

      final Result<int> result = await guard<int>(
        () => throw AppError(kind: AppErrorKind.parsing, cause: cause),
      );

      expect((result as Failure<int>).error.kind, AppErrorKind.parsing);
      expect(reports.single.error, same(cause));
    });

    test('a bad cast is a reported parsing error', () async {
      final Result<int> result = await guard<int>(() async {
        final Object body = <String, dynamic>{'data': <dynamic>[]};
        return (body as Map<String, dynamic>)['data'] as int;
      });

      expect((result as Failure<int>).error.kind, AppErrorKind.parsing);
      expect(reports.single.error, isA<TypeError>());
    });

    test('a FormatException is a reported parsing error', () async {
      final Result<int> result = await guard<int>(() async => int.parse('x'));

      expect((result as Failure<int>).error.kind, AppErrorKind.parsing);
      expect(reports.single.error, isA<FormatException>());
    });

    test('anything else is a reported unknown error with its trace', () async {
      final Result<int> result = await guard<int>(
        () => Future<int>.error(StateError('bug'), marker),
      );

      expect((result as Failure<int>).error.kind, AppErrorKind.unknown);
      expect(reports.single.error, isA<StateError>());
      expect(reports.single.stackTrace.toString(), contains('MARKER_FRAME'));
    });

    test('a write that returns no record succeeds as Result<void>', () async {
      final ApiClient client = stubApiClient(
        (_) => jsonResponse('{"data":[],"meta":{"message":"Saved"}}'),
      );

      final Result<void> result = await guard(() async {
        await client.post('things');
      });

      expect(result, isA<Success<void>>());
    });
  });

  group('ApiErrorMapper.translate', () {
    const ApiErrorMapper mapper = ApiErrorMapper();

    test('rethrows a DioException as an AppError with the same trace', () {
      return expectLater(
        () => mapper.translate<void>(
          () => throw dioError(
            DioExceptionType.connectionTimeout,
            stackTrace: marker,
          ),
        ),
        throwsA(
          isA<AppError>().having(
            (AppError e) => e.kind,
            'kind',
            AppErrorKind.timeout,
          ),
        ),
      );
    });

    test('keeps the DioException stack trace', () async {
      try {
        await mapper.translate<void>(
          () => throw dioError(
            DioExceptionType.connectionTimeout,
            stackTrace: marker,
          ),
        );
        fail('should have thrown');
      } on AppError catch (_, stackTrace) {
        expect(stackTrace.toString(), contains('MARKER_FRAME'));
      }
    });

    test('lets anything that is not a DioException through untouched', () {
      return expectLater(
        () => mapper.translate<void>(() => throw StateError('bug')),
        throwsStateError,
      );
    });

    test('an unknown error with no response is a network error', () {
      final AppError error = mapper.map(dioError(DioExceptionType.unknown));

      expect(error.kind, AppErrorKind.network);
      expect(error.cause, isNull);
    });
  });

  group('ErrorHandler (legacy repositories on a raw Dio)', () {
    test('maps a response with field errors', () async {
      final Result<int> result = await ErrorHandler.guard<int>(
        () async => throw dioError(
          DioExceptionType.badResponse,
          response: responseOf(422, <String, dynamic>{
            'message': 'Invalid',
            'errors': <String, dynamic>{
              'email': <String>['Taken'],
            },
          }),
        ),
      );

      final AppError error = (result as Failure<int>).error;
      expect(error.kind, AppErrorKind.validation);
      expect(error.fieldError('email'), 'Taken');
    });

    test('maps a 401 to unauthorized', () async {
      final Result<int> result = await ErrorHandler.guard<int>(
        () async => throw dioError(
          DioExceptionType.badResponse,
          response: responseOf(401, <String, dynamic>{}),
        ),
      );

      final AppError error = (result as Failure<int>).error;
      expect(error.kind, AppErrorKind.unauthorized);
      expect(error.statusCode, 401);
    });

    test('passes an AppError through without reporting it', () async {
      const AppError thrown = AppError(kind: AppErrorKind.forbidden);

      final Result<int> result = await ErrorHandler.guard<int>(
        () => throw thrown,
      );

      expect((result as Failure<int>).error, thrown);
      expect(reports, isEmpty);
    });

    test('reports a parsing bug like guard does', () async {
      final Result<int> result = await ErrorHandler.guard<int>(
        () async => throw TypeError(),
      );

      expect((result as Failure<int>).error.kind, AppErrorKind.parsing);
      expect(reports.single.error, isA<TypeError>());
    });
  });
}
