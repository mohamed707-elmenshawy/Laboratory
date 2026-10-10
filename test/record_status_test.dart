import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/branches/data/models/branch_model.dart';
import 'package:laboratory/branches/data/models/update_branch_request_body.dart';
import 'package:laboratory/branches/data/repos/branches_repo.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/phones/phones.dart';
import 'package:laboratory/core/networking/api_constants.dart';
import 'package:laboratory/laboratories/data/models/laboratories_query.dart';
import 'package:laboratory/laboratories/data/models/laboratory_model.dart';
import 'package:laboratory/laboratories/data/models/update_laboratory_request_body.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';
import 'package:laboratory/laboratories/logic/laboratory_status_cubit.dart';
import 'package:laboratory/parameters/data/repos/parameters_repo.dart';
import 'package:laboratory/sample_types/data/repos/sample_types_repo.dart';
import 'package:laboratory/test_categories/data/repos/test_categories_repo.dart';
import 'package:laboratory/units/data/repos/units_repo.dart';

class _Call {
  const _Call(this.method, this.path, this.query);

  final String method;
  final String path;
  final Map<String, dynamic> query;
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({this.show});

  final Map<String, dynamic>? show;
  final List<_Call> calls = <_Call>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(
      _Call(options.method, options.uri.path, options.uri.queryParameters),
    );

    final Object body = options.method == 'GET'
        ? <String, dynamic>{'data': show}
        : <String, dynamic>{
            'data': <dynamic>[],
            'meta': <String, dynamic>{'message': 'Done', 'code': 200},
          };

    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_RecordingAdapter adapter) =>
    Dio(BaseOptions(baseUrl: ApiConstants.baseUrl))
      ..httpClientAdapter = adapter;

const Map<String, dynamic> _laboratoryJson = <String, dynamic>{
  'id': 5,
  'name': 'Walter-Rempel',
  'is_active': true,
  'branches_count': 3,
  'admin': 'Dr. Rempel',
};

const Map<String, dynamic> _branchJson = <String, dynamic>{
  'id': 7,
  'name': 'Zemlak-Pollich',
  'is_active': false,
  'is_main_branch': true,
};

void main() {
  group('activate and deactivate take the id of their own record', () {
    test('laboratory status hits laboratories/{id}/activate', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final LaboratoriesRepo repo = LaboratoriesRepo(_dio(adapter));

      final Result<void> activated = await repo.setLaboratoryActive(5, true);
      final Result<void> deactivated = await repo.setLaboratoryActive(2, false);

      expect(activated, isA<Success<void>>());
      expect(deactivated, isA<Success<void>>());
      expect(adapter.calls.map((_Call call) => call.method), <String>[
        'PATCH',
        'PATCH',
      ]);
      expect(adapter.calls.map((_Call call) => call.path), <String>[
        '/api/v1/laboratories/5/activate',
        '/api/v1/laboratories/2/deactivate',
      ]);
    });

    test('branch status hits branches/{id}/activate', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final BranchesRepo repo = BranchesRepo(_dio(adapter));

      expect(await repo.setBranchActive(7, true), isA<Success<void>>());
      expect(await repo.setBranchActive(7, false), isA<Success<void>>());
      expect(adapter.calls.map((_Call call) => call.path), <String>[
        '/api/v1/branches/7/activate',
        '/api/v1/branches/7/deactivate',
      ]);
    });

    test('sample type status hits sample-types/{id}/activate', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final SampleTypesRepo repo = SampleTypesRepo(_dio(adapter));

      expect(await repo.setSampleTypeActive(6, true), isA<Success<void>>());
      expect(await repo.setSampleTypeActive(6, false), isA<Success<void>>());
      expect(adapter.calls.map((_Call call) => call.path), <String>[
        '/api/v1/sample-types/6/activate',
        '/api/v1/sample-types/6/deactivate',
      ]);
    });

    test('parameter status hits parameters/{id}/activate', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final ParametersRepo repo = ParametersRepo(_dio(adapter));

      expect(await repo.setParameterActive(2, true), isA<Success<void>>());
      expect(await repo.setParameterActive(7, false), isA<Success<void>>());
      expect(adapter.calls.map((_Call call) => call.path), <String>[
        '/api/v1/parameters/2/activate',
        '/api/v1/parameters/7/deactivate',
      ]);
    });

    test('unit status hits units/{id}/activate', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final UnitsRepo repo = UnitsRepo(_dio(adapter));

      expect(await repo.setUnitActive(3, true), isA<Success<void>>());
      expect(await repo.setUnitActive(8, false), isA<Success<void>>());
      expect(adapter.calls.map((_Call call) => call.path), <String>[
        '/api/v1/units/3/activate',
        '/api/v1/units/8/deactivate',
      ]);
    });

    test('category status hits test-categories/{id}/activate', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final TestCategoriesRepo repo = TestCategoriesRepo(_dio(adapter));

      expect(await repo.setTestCategoryActive(9, true), isA<Success<void>>());
      expect(await repo.setTestCategoryActive(4, false), isA<Success<void>>());
      expect(adapter.calls.map((_Call call) => call.path), <String>[
        '/api/v1/test-categories/9/activate',
        '/api/v1/test-categories/4/deactivate',
      ]);
    });
  });

  group('writes that answer with an empty data payload', () {
    test('the status toggle reports the flag it asked for', () async {
      final _RecordingAdapter adapter = _RecordingAdapter();
      final LaboratoryStatusCubit cubit = LaboratoryStatusCubit(
        LaboratoriesRepo(_dio(adapter)),
      );

      const LaboratoryModel laboratory = LaboratoryModel(
        id: 5,
        name: 'Walter-Rempel',
        isActive: false,
        branchesCount: 3,
      );

      await cubit.toggle(laboratory);

      expect(cubit.state, isA<LaboratoryStatusSuccess>());
      expect(
        (cubit.state as LaboratoryStatusSuccess).laboratory,
        laboratory.withActive(true),
      );
      expect(adapter.calls.single.path, '/api/v1/laboratories/5/activate');
    });

    test('updating a laboratory reads the record back', () async {
      final _RecordingAdapter adapter = _RecordingAdapter(
        show: _laboratoryJson,
      );
      final LaboratoriesRepo repo = LaboratoriesRepo(_dio(adapter));

      final Result<LaboratoryModel> result = await repo.updateLaboratory(
        5,
        const UpdateLaboratoryRequestBody(lang: 'en', name: 'Walter-Rempel'),
      );

      expect(result, isA<Success<LaboratoryModel>>());
      expect((result as Success<LaboratoryModel>).data.branchesCount, 3);
      expect(adapter.calls.map((_Call call) => call.method), <String>[
        'POST',
        'GET',
      ]);
      expect(adapter.calls.last.path, '/api/v1/laboratories/5');
    });

    test('updating a branch reads the record back', () async {
      final _RecordingAdapter adapter = _RecordingAdapter(show: _branchJson);
      final BranchesRepo repo = BranchesRepo(_dio(adapter));

      final Result<BranchModel> result = await repo.updateBranch(
        7,
        const UpdateBranchRequestBody(
          lang: 'en',
          name: 'Zemlak-Pollich',
          laboratoryId: 2,
          isMainBranch: true,
          address: '',
          phones: <PhonePayload>[],
        ),
      );

      expect(result, isA<Success<BranchModel>>());
      expect((result as Success<BranchModel>).data.id, 7);
      expect(adapter.calls.map((_Call call) => call.method), <String>[
        'POST',
        'GET',
      ]);
      expect(adapter.calls.last.path, '/api/v1/branches/7');
    });
  });

  test('the laboratories list asks for a page size the API reads', () async {
    final _RecordingAdapter adapter = _RecordingAdapter(
      show: <String, dynamic>{
        'items': <dynamic>[],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': 0,
            'per_page': 10,
            'current_page': 1,
            'last_page': 1,
          },
        },
      },
    );

    await LaboratoriesRepo(
      _dio(adapter),
    ).fetchLaboratories(const LaboratoriesQuery(page: 1, pageSize: 10));

    expect(adapter.calls.single.query['per_page'], '10');
  });
}
