import 'package:dio/dio.dart';

import '../../../core/error/error_handler.dart';
import '../../../core/error/result.dart';
import '../../../core/networking/api_constants.dart';
import '../models/branch_model.dart';
import '../models/branches_page.dart';
import '../models/branches_query.dart';
import '../models/update_branch_request_body.dart';

class BranchesRepo {
  final Dio _dio;

  const BranchesRepo(this._dio);

  Future<Result<BranchesPage>> fetchBranches(BranchesQuery query) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get(
        ApiConstants.branches,
        queryParameters: query.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return BranchesPage.fromJson(data);
    });
  }

  Future<Result<BranchModel>> fetchBranch(int id) {
    return ErrorHandler.guard(() async {
      final response = await _dio.get('${ApiConstants.branches}/$id');

      final Map<String, dynamic> data = response.data!['data'];
      return BranchModel.fromJson(data);
    });
  }

  Future<Result<void>> createBranch(UpdateBranchRequestBody body) {
    return ErrorHandler.guard(() async {
      await _dio.post(ApiConstants.branches, data: body.toJson());
    });
  }

  Future<Result<BranchModel>> updateBranch(
    int id,
    UpdateBranchRequestBody body,
  ) {
    return ErrorHandler.guard(() async {
      final response = await _dio.post(
        '${ApiConstants.branches}/$id',
        data: body.toJson(),
      );

      final Map<String, dynamic> data = response.data!['data'];
      return BranchModel.fromJson(data);
    });
  }

  Future<Result<void>> deleteBranch(int id) {
    return ErrorHandler.guard(() async {
      await _dio.delete('${ApiConstants.branches}/$id');
    });
  }
}
