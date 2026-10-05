import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/core/ui/ui.dart';
import 'package:laboratory/branches/data/models/branch_model.dart';
import 'package:laboratory/branches/data/models/branches_page.dart';
import 'package:laboratory/branches/data/models/branches_query.dart';
import 'package:laboratory/branches/data/models/update_branch_request_body.dart';
import 'package:laboratory/branches/data/repos/branches_repo.dart';
import 'package:laboratory/laboratories/data/models/laboratory_menu_item.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';
import 'package:laboratory/sample_types/UI/sample_types_view.dart';
import 'package:laboratory/sample_types/data/models/sample_types_page.dart';
import 'package:laboratory/sample_types/data/models/sample_types_query.dart';
import 'package:laboratory/sample_types/data/models/sample_type_model.dart';
import 'package:laboratory/sample_types/data/models/sample_type_request_body.dart';
import 'package:laboratory/sample_types/data/repos/sample_types_repo.dart';
import 'package:laboratory/sample_types/logic/delete_sample_type_cubit.dart';
import 'package:laboratory/sample_types/logic/sample_types_cubit.dart';
import 'package:laboratory/sample_types/logic/sample_type_status_cubit.dart';
import 'package:laboratory/sample_types/logic/sample_type_details_cubit.dart';
import 'package:laboratory/sample_types/logic/sample_type_form_cubit.dart';

import 'support/fake_laboratories_repo.dart';

Map<String, dynamic> _sampleTypeJson({
  int id = 5,
  String name = 'Gerlach Ltd',
  bool isActive = false,
  String? description = 'Quality-focused superstructure',
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'description': description,
  'is_active': isActive,
  'branch': <String, dynamic>{'id': 2, 'name': 'Zemlak-Pollich'},
  'laboratory': <String, dynamic>{
    'id': 2,
    'name': 'Heathcote, Walsh and Jones',
  },
};

class FakeSampleTypesRepo implements SampleTypesRepo {
  FakeSampleTypesRepo({this.showError, this.deleteError, this.statusError});

  final AppError? showError;
  final AppError? deleteError;
  final AppError? statusError;

  final List<Map<String, Object>> statusCalls = <Map<String, Object>>[];

  final List<SampleTypesQuery> queries = <SampleTypesQuery>[];
  final List<int> shown = <int>[];
  final List<int> deleted = <int>[];
  final List<Map<String, dynamic>> created = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> saved = <Map<String, dynamic>>[];

  @override
  Future<Result<SampleTypesPage>> fetchSampleTypes(
    SampleTypesQuery query,
  ) async {
    queries.add(query);

    return Success<SampleTypesPage>(
      SampleTypesPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          _sampleTypeJson(),
          _sampleTypeJson(
            id: 3,
            name: 'Pfannerstill Inc',
            isActive: true,
            description: null,
          ),
        ],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': 2,
            'per_page': query.perPage,
            'current_page': query.page,
            'last_page': 1,
            'from': 1,
            'to': 2,
          },
        },
      }),
    );
  }

  @override
  Future<Result<SampleTypeModel>> fetchSampleType(int id) async {
    shown.add(id);

    if (showError != null) return Failure<SampleTypeModel>(showError!);
    return Success<SampleTypeModel>(
      SampleTypeModel.fromJson(_sampleTypeJson(id: id)),
    );
  }

  @override
  Future<Result<void>> createSampleType(SampleTypeRequestBody body) async {
    created.add(body.toJson());
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> updateSampleType(
    int id,
    SampleTypeRequestBody body,
  ) async {
    saved.add(<String, dynamic>{'id': id, ...body.toJson()});
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> deleteSampleType(int id) async {
    deleted.add(id);

    if (deleteError != null) return Failure<void>(deleteError!);
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> setSampleTypeActive(int id, bool active) async {
    statusCalls.add(<String, Object>{'id': id, 'active': active});

    if (statusError != null) return Failure<void>(statusError!);
    return const Success<void>(null);
  }
}

class FakeBranchesRepo implements BranchesRepo {
  final List<BranchesQuery> queries = <BranchesQuery>[];

  @override
  Future<Result<BranchesPage>> fetchBranches(BranchesQuery query) async {
    queries.add(query);

    return Success<BranchesPage>(
      BranchesPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 2,
            'name': 'Zemlak-Pollich',
            'is_active': true,
            'is_main_branch': true,
            'laboratory': <String, dynamic>{'id': 2, 'name': 'Heathcote'},
          },
        ],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': 1,
            'per_page': query.perPage,
            'current_page': 1,
            'last_page': 1,
          },
        },
      }),
    );
  }

  @override
  Future<Result<BranchModel>> fetchBranch(int id) async =>
      throw UnimplementedError();

  @override
  Future<Result<void>> createBranch(UpdateBranchRequestBody body) async =>
      throw UnimplementedError();

  @override
  Future<Result<BranchModel>> updateBranch(
    int id,
    UpdateBranchRequestBody body,
  ) async => throw UnimplementedError();

  @override
  Future<Result<void>> deleteBranch(int id) async => throw UnimplementedError();

  @override
  Future<Result<void>> setBranchActive(int id, bool active) async =>
      throw UnimplementedError();
}

class MenuRepo extends FakeLaboratoriesRepoBase {
  @override
  Future<Result<List<LaboratoryMenuItem>>> fetchLaboratoriesMenu({
    String search = '',
  }) async => const Success<List<LaboratoryMenuItem>>(<LaboratoryMenuItem>[
    LaboratoryMenuItem(id: 2, name: 'Heathcote, Walsh and Jones'),
  ]);
}

Widget _app(SampleTypesCubit cubit, SampleTypeStatusCubit status) =>
    AppLocaleScope(
      child: MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<SampleTypesCubit>.value(value: cubit),
              BlocProvider<SampleTypeStatusCubit>.value(value: status),
            ],
            child: const SampleTypesView(),
          ),
        ),
      ),
    );

Future<void> _open(WidgetTester tester, FakeSampleTypesRepo repo) async {
  getIt.registerLazySingleton<LaboratoriesRepo>(MenuRepo.new);
  getIt.registerFactory<SampleTypeDetailsCubit>(
    () => SampleTypeDetailsCubit(repo),
  );
  getIt.registerFactory<DeleteSampleTypeCubit>(
    () => DeleteSampleTypeCubit(repo),
  );
  getIt.registerFactory<SampleTypeFormCubit>(
    () => SampleTypeFormCubit(repo, MenuRepo(), FakeBranchesRepo()),
  );
  addTearDown(() {
    getIt.unregister<LaboratoriesRepo>();
    getIt.unregister<SampleTypeDetailsCubit>();
    getIt.unregister<DeleteSampleTypeCubit>();
    getIt.unregister<SampleTypeFormCubit>();
  });

  tester.view.physicalSize = const Size(1500, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final SampleTypesCubit cubit = SampleTypesCubit(repo)..load();
  addTearDown(cubit.close);

  final SampleTypeStatusCubit status = SampleTypeStatusCubit(repo);
  addTearDown(status.close);

  await tester.pumpWidget(_app(cubit, status));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the list asks for page 1 with per_page 10 and renders rows', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    expect(repo.queries.single.toJson(), <String, dynamic>{
      'page': 1,
      'per_page': 10,
    });
    expect(find.text('Gerlach Ltd'), findsOneWidget);
    expect(find.text('Pfannerstill Inc'), findsOneWidget);
    expect(find.text('Heathcote, Walsh and Jones'), findsNWidgets(2));
    expect(find.text('No description'), findsOneWidget);
    expect(find.text('Showing 1 to 2 of 2 results'), findsOneWidget);
  });

  testWidgets('the row toggle activates that sample type and only that one', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Activate').first);
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <Map<String, Object>>[
      <String, Object>{'id': 5, 'active': true},
    ]);
    expect(find.text('Sample type activated'), findsOneWidget);
  });

  testWidgets('the toggle of the second row carries its own id', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Deactivate').first);
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <Map<String, Object>>[
      <String, Object>{'id': 3, 'active': false},
    ]);
    expect(find.text('Sample type deactivated'), findsOneWidget);
  });

  testWidgets('status and laboratory filters reach the query', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(
      find.descendant(
        of: find.byType(AppSegmentedFilter<SampleTypeStatusFilter>),
        matching: find.text('Active'),
      ),
    );
    await tester.pumpAndSettle();
    expect(repo.queries.last.toJson()['is_active'], 1);

    await tester.tap(find.byType(AppSelect<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heathcote, Walsh and Jones').last);
    await tester.pumpAndSettle();

    expect(repo.queries.last.toJson()['laboratory_id'], 2);
    expect(repo.queries.last.page, 1);
  });

  testWidgets('the view action opens the details page for that row', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[5]);
    expect(find.text('Back to sample types'), findsOneWidget);
    expect(find.text('Gerlach Ltd'), findsOneWidget);
    expect(find.text('Quality-focused superstructure'), findsOneWidget);
    expect(find.text('Zemlak-Pollich'), findsOneWidget);
  });

  testWidgets('a missing sample type explains itself and retries', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo(
      showError: const AppError(kind: AppErrorKind.notFound, statusCode: 404),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(
      find.text('This sample type is no longer there. Refresh the list.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.shown, <int>[5, 5]);
  });

  testWidgets('deleting from the list asks first, then refreshes', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    final int before = repo.queries.length;

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Delete Gerlach Ltd?'), findsOneWidget);
    expect(
      find.text('It moves to the trash, so an admin can still restore it.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[5]);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Sample type deleted'), findsOneWidget);
    expect(repo.queries.length, before + 1);
  });

  testWidgets('cancelling the delete changes nothing', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repo.deleted, isEmpty);
    expect(find.text('Sample type deleted'), findsNothing);
  });

  testWidgets('a failed delete keeps the dialog open with the reason', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo(
      deleteError: const AppError(
        kind: AppErrorKind.forbidden,
        statusCode: 403,
        message: 'This action is unauthorized.',
      ),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('This action is unauthorized.'), findsOneWidget);
    expect(find.text('Sample type deleted'), findsNothing);
  });

  testWidgets('deleting from the details page returns to the list', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[5]);
    expect(find.text('Back to sample types'), findsNothing);
    expect(find.text('Sample type deleted'), findsOneWidget);
  });

  testWidgets('creating posts every field without an id', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New sample type'));
    await tester.pumpAndSettle();

    expect(
      find.text('Add a sample type to a branch of one of your laboratories.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).first, 'Haematology');
    await tester.enterText(find.byType(TextField).at(1), 'Blood work');

    await tester.tap(find.byType(AppSelect<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heathcote, Walsh and Jones').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppSelect<int>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zemlak-Pollich').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created.single, <String, dynamic>{
      'lang': 'en',
      'name': 'Haematology',
      'description': 'Blood work',
      'laboratory_id': 2,
      'branch_id': 2,
    });
    expect(find.text('Sample type created'), findsOneWidget);
  });

  testWidgets('create blocks until a laboratory and branch are chosen', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New sample type'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Haematology');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created, isEmpty);
  });

  testWidgets('editing prefills the row and posts to its id', (
    WidgetTester tester,
  ) async {
    final FakeSampleTypesRepo repo = FakeSampleTypesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[5]);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Gerlach Ltd',
    );

    await tester.enterText(find.byType(TextField).first, 'Gerlach edited');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(repo.queries.length, greaterThan(1));
    expect(repo.saved.single, <String, dynamic>{
      'id': 5,
      'lang': 'en',
      'name': 'Gerlach edited',
      'description': 'Quality-focused superstructure',
      'laboratory_id': 2,
      'branch_id': 2,
    });
    expect(find.text('Sample type saved'), findsOneWidget);
  });
}
