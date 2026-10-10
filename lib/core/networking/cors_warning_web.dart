import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

void disableCorsWarning(Dio dio) {
  final HttpClientAdapter adapter = dio.httpClientAdapter;
  if (adapter is BrowserHttpClientAdapter) {
    adapter.enableCORSWarning = false;
  }
}
