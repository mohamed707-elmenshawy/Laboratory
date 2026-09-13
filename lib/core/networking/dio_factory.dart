import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

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
        },
        validateStatus: (int? status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    if (kDebugMode) {
      dio!.interceptors.add(
        PrettyDioLogger(
          requestBody: false,
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
    dio?.options.headers[ApiConstants.acceptLanguageHeader] = localeCode;
  }
}
