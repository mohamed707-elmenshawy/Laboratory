import 'dart:convert';

import 'responses.dart';

abstract final class FakeApi {
  static const Duration latency = Duration(milliseconds: 600);

  static Future<dynamic> get(String path) async {
    await Future<void>.delayed(latency);
    return jsonDecode(rawBody(path));
  }

  static String rawBody(String path) {
    final String? body = FakeResponses.byPath[path];
    if (body == null) {
      throw StateError('404 Not Found: $path');
    }
    return body;
  }
}
