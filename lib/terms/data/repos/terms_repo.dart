import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/term_model.dart';

class TermsRepo {
  const TermsRepo(this._dio);

  final Dio _dio;

  Future<Result<List<TermModel>>> fetchTerms() {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(ApiConstants.termsList);

      final List<dynamic> data = response.data!['data'] as List<dynamic>;
      return data
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) =>
                TermModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .where((TermModel term) => term.isActive)
          .toList(growable: false);
    });
  }
}
