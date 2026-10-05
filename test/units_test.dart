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
import 'package:laboratory/units/UI/units_view.dart';
import 'package:laboratory/units/data/models/units_page.dart';
import 'package:laboratory/units/data/models/units_query.dart';
import 'package:laboratory/units/data/models/unit_model.dart';
import 'package:laboratory/units/data/models/unit_request_body.dart';
import 'package:laboratory/units/data/repos/units_repo.dart';
import 'package:laboratory/units/logic/delete_unit_cubit.dart';
import 'package:laboratory/units/logic/units_cubit.dart';
import 'package:laboratory/units/logic/unit_status_cubit.dart';
import 'package:laboratory/units/logic/unit_details_cubit.dart';
import 'package:laboratory/units/logic/unit_form_cubit.dart';

import 'support/fake_laboratories_repo.dart';

Map<String, dynamic> _unitJson({
  int id = 5,
  String name = 'Gerlach Ltd',
  String symbol = 'g/L',
  bool isActive = false,
  String? description = 'Quality-focused superstructure',
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'symbol': symbol,
  'description': description,
  'is_active': isActive,
  'branch': <String, dynamic>{'id': 2, 'name': 'Zemlak-Pollich'},
  'laboratory': <String, dynamic>{
    'id': 2,
    'name': 'Heathcote, Walsh and Jones',
  },
};

class FakeUnitsRepo implements UnitsRepo {
  FakeUnitsRepo({this.showError, this.deleteError, this.statusError});

  final AppError? showError;
  final AppError? deleteError;
  final AppError? statusError;

  final List<Map<String, Object>> statusCalls = <Map<String, Object>>[];

  final List<UnitsQuery> queries = <UnitsQuery>[];
  final List<int> shown = <int>[];
  final List<int> deleted = <int>[];
  final List<Map<String, dynamic>> created = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> saved = <Map<String, dynamic>>[];

  @override
  Future<Result<UnitsPage>> fetchUnits(UnitsQuery query) async {
    queries.add(query);

    return Success<UnitsPage>(
      UnitsPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          _unitJson(),
          _unitJson(
            id: 3,
            name: 'Pfannerstill Inc',
            symbol: 'mL',
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
  Future<Result<UnitModel>> fetchUnit(int id) async {
    shown.add(id);

    if (showError != null) return Failure<UnitModel>(showError!);
    return Success<UnitModel>(UnitModel.fromJson(_unitJson(id: id)));
  }

  @override
  Future<Result<void>> createUnit(UnitRequestBody body) async {
    created.add(body.toJson());
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> updateUnit(int id, UnitRequestBody body) async {
    saved.add(<String, dynamic>{'id': id, ...body.toJson()});
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> deleteUnit(int id) async {
    deleted.add(id);

    if (deleteError != null) return Failure<void>(deleteError!);
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> setUnitActive(int id, bool active) async {
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

Widget _app(UnitsCubit cubit, UnitStatusCubit status) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<UnitsCubit>.value(value: cubit),
          BlocProvider<UnitStatusCubit>.value(value: status),
        ],
        child: const UnitsView(),
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester, FakeUnitsRepo repo) async {
  getIt.registerLazySingleton<LaboratoriesRepo>(MenuRepo.new);
  getIt.registerFactory<UnitDetailsCubit>(() => UnitDetailsCubit(repo));
  getIt.registerFactory<DeleteUnitCubit>(() => DeleteUnitCubit(repo));
  getIt.registerFactory<UnitFormCubit>(
    () => UnitFormCubit(repo, MenuRepo(), FakeBranchesRepo()),
  );
  addTearDown(() {
    getIt.unregister<LaboratoriesRepo>();
    getIt.unregister<UnitDetailsCubit>();
    getIt.unregister<DeleteUnitCubit>();
    getIt.unregister<UnitFormCubit>();
  });

  tester.view.physicalSize = const Size(1500, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final UnitsCubit cubit = UnitsCubit(repo)..load();
  addTearDown(cubit.close);

  final UnitStatusCubit status = UnitStatusCubit(repo);
  addTearDown(status.close);

  await tester.pumpWidget(_app(cubit, status));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the list asks for page 1 with per_page 10 and renders rows', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    expect(repo.queries.single.toJson(), <String, dynamic>{
      'page': 1,
      'per_page': 10,
    });
    expect(find.text('Gerlach Ltd'), findsOneWidget);
    expect(find.text('Pfannerstill Inc'), findsOneWidget);
    expect(find.text('g/L'), findsOneWidget);
    expect(find.text('mL'), findsOneWidget);
    expect(find.text('Heathcote, Walsh and Jones'), findsNWidgets(2));
    expect(find.text('No description'), findsOneWidget);
    expect(find.text('Showing 1 to 2 of 2 results'), findsOneWidget);
  });

  testWidgets('the row toggle activates that unit and only that one', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Activate').first);
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <Map<String, Object>>[
      <String, Object>{'id': 5, 'active': true},
    ]);
    expect(find.text('Unit activated'), findsOneWidget);
  });

  testWidgets('the toggle of the second row carries its own id', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Deactivate').first);
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <Map<String, Object>>[
      <String, Object>{'id': 3, 'active': false},
    ]);
    expect(find.text('Unit deactivated'), findsOneWidget);
  });

  testWidgets('status and laboratory filters reach the query', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(
      find.descendant(
        of: find.byType(AppSegmentedFilter<UnitStatusFilter>),
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
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[5]);
    expect(find.text('Back to units'), findsOneWidget);
    expect(find.text('Gerlach Ltd'), findsOneWidget);
    expect(find.text('Quality-focused superstructure'), findsOneWidget);
    expect(find.text('Zemlak-Pollich'), findsOneWidget);
  });

  testWidgets('a missing unit explains itself and retries', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo(
      showError: const AppError(kind: AppErrorKind.notFound, statusCode: 404),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(
      find.text('This unit is no longer there. Refresh the list.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.shown, <int>[5, 5]);
  });

  testWidgets('deleting from the list asks first, then refreshes', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
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
    expect(find.text('Unit deleted'), findsOneWidget);
    expect(repo.queries.length, before + 1);
  });

  testWidgets('cancelling the delete changes nothing', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repo.deleted, isEmpty);
    expect(find.text('Unit deleted'), findsNothing);
  });

  testWidgets('a failed delete keeps the dialog open with the reason', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo(
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
    expect(find.text('Unit deleted'), findsNothing);
  });

  testWidgets('deleting from the details page returns to the list', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[5]);
    expect(find.text('Back to units'), findsNothing);
    expect(find.text('Unit deleted'), findsOneWidget);
  });

  testWidgets('creating posts every field without an id', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New unit'));
    await tester.pumpAndSettle();

    expect(
      find.text('Add a unit to a branch of one of your laboratories.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).first, 'Haematology');
    await tester.enterText(find.byType(TextField).at(1), 'mmol/L');
    await tester.enterText(find.byType(TextField).at(2), 'Blood work');

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
      'symbol': 'mmol/L',
      'description': 'Blood work',
      'laboratory_id': 2,
      'branch_id': 2,
    });
    expect(find.text('Unit created'), findsOneWidget);
  });

  testWidgets('create blocks until a laboratory and branch are chosen', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New unit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Haematology');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created, isEmpty);
  });

  testWidgets('editing prefills the row and posts to its id', (
    WidgetTester tester,
  ) async {
    final FakeUnitsRepo repo = FakeUnitsRepo();
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
      'symbol': 'g/L',
      'description': 'Quality-focused superstructure',
      'laboratory_id': 2,
      'branch_id': 2,
    });
    expect(find.text('Unit saved'), findsOneWidget);
  });
}
