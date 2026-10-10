import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';
import 'cors_warning.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;
  static String _localeCode = 'EN';

  static String get localeCode => _localeCode;

  static Dio getDio() {
    if (dio != null) return dio!;

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          ApiConstants.acceptLanguageHeader: _localeCode,
        },
        validateStatus: (int? status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    disableCorsWarning(dio!);

    dio!.interceptors.add(_LocaleInterceptor());

    if (kDebugMode) {
      dio!.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }

    return dio!;
  }

  static void setSessionHeaders({required String token, String? tenantId}) {
    dio?.options.headers[ApiConstants.authorizationHeader] = 'Bearer $token';

    if (tenantId == null || tenantId.isEmpty) {
      dio?.options.headers.remove(ApiConstants.tenantHeader);
    } else {
      dio?.options.headers[ApiConstants.tenantHeader] = tenantId;
    }
  }

  static void clearSessionHeaders() {
    dio?.options.headers.remove(ApiConstants.authorizationHeader);
    dio?.options.headers.remove(ApiConstants.tenantHeader);
  }

  static void setLocale(String localeCode) {
    final String header = localeCode.trim().toUpperCase();
    if (header.isEmpty) return;

    _localeCode = header;
    dio?.options.headers[ApiConstants.acceptLanguageHeader] = header;
  }
}

class _LocaleInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConstants.acceptLanguageHeader] = DioFactory.localeCode;
    handler.next(options);
  }
}
