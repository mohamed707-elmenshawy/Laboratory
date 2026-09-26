import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/laboratories/data/models/create_laboratory_request_body.dart';
import 'package:laboratory/laboratories/data/models/laboratories_page.dart';
import 'package:laboratory/laboratories/data/models/laboratories_query.dart';
import 'package:laboratory/laboratories/data/models/laboratory_model.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';

LaboratoriesPage emptyLaboratoriesPage() =>
    LaboratoriesPage.fromJson(const <String, dynamic>{
      'items': <dynamic>[],
      'pagination': <String, dynamic>{
        'meta': <String, dynamic>{
          'total': 0,
          'per_page': 10,
          'current_page': 1,
          'last_page': 1,
        },
      },
    });

const LaboratoryModel sampleLaboratory = LaboratoryModel(
  id: 1,
  name: 'Laboratory 1',
  isActive: true,
  branchesCount: 0,
  admin: 'Tenant 1',
);

class FakeLaboratoriesRepoBase implements LaboratoriesRepo {
  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async => Success<LaboratoriesPage>(emptyLaboratoriesPage());

  @override
  Future<Result<LaboratoryModel>> fetchLaboratory(int id) async =>
      const Success<LaboratoryModel>(sampleLaboratory);

  @override
  Future<Result<LaboratoryModel>> setLaboratoryActive(
    int id,
    bool active,
  ) async => const Success<LaboratoryModel>(sampleLaboratory);

  @override
  Future<Result<void>> createLaboratory(
    CreateLaboratoryRequestBody body,
  ) async => const Success<void>(null);

  @override
  Future<Result<void>> deleteLaboratory(int id) async =>
      const Success<void>(null);
}
