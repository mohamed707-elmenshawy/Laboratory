import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

// The backend handles CORS preflight, so the per-request warning is noise.
HttpClientAdapter createClientAdapter() =>
    BrowserHttpClientAdapter(enableCORSWarning: false);
