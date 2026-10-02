import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/branches/UI/branches_view.dart';
import 'package:laboratory/branches/data/models/branch_model.dart';
import 'package:laboratory/branches/data/models/branches_page.dart';
import 'package:laboratory/branches/data/models/branches_query.dart';
import 'package:laboratory/branches/data/models/update_branch_request_body.dart';
import 'package:laboratory/branches/data/repos/branches_repo.dart';
import 'package:laboratory/branches/logic/branch_details_cubit.dart';
import 'package:laboratory/branches/logic/branches_cubit.dart';
import 'package:laboratory/branches/logic/delete_branch_cubit.dart';
import 'package:laboratory/branches/logic/update_branch_cubit.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/core/ui/ui.dart';
import 'package:laboratory/laboratories/data/models/laboratory_menu_item.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';

import 'support/fake_laboratories_repo.dart';

Map<String, dynamic> _branchJson({
  int id = 13,
  String name = 'Cairo branch',
  bool isActive = true,
  bool isMain = true,
  int labId = 1,
  String labName = 'Lubowitz Lab',
  List<Map<String, dynamic>>? phones,
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'address': 'test address',
  'is_active': isActive,
  'is_main_branch': isMain,
  'phones':
      phones ??
      <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 39,
          'phone': '01095538077',
          'phone_country': 'EG',
          'type': 'both',
          'type_label': 'Both',
          'dial_code': '+20',
        },
      ],
  'laboratory': <String, dynamic>{'id': labId, 'name': labName},
  'manager': null,
};

class FakeBranchesRepo implements BranchesRepo {
  FakeBranchesRepo({this.total = 2, this.updateError, this.deleteError});

  final int total;
  final AppError? updateError;
  final AppError? deleteError;

  final List<BranchesQuery> queries = <BranchesQuery>[];
  final List<Map<String, dynamic>> saved = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> created = <Map<String, dynamic>>[];
  final List<int> deleted = <int>[];
  int shows = 0;

  @override
  Future<Result<BranchesPage>> fetchBranches(BranchesQuery query) async {
    queries.add(query);

    final int count = query.page == 1
        ? (total > query.perPage ? query.perPage : total)
        : 1;

    return Success<BranchesPage>(
      BranchesPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          for (int i = 0; i < count; i++)
            _branchJson(
              id: 13 - i,
              name: i == 0 ? 'Cairo branch' : 'Giza branch',
              isActive: i == 0,
              isMain: i == 0,
            ),
        ],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': total,
            'per_page': query.perPage,
            'current_page': query.page,
            'last_page': (total / query.perPage).ceil().clamp(1, 99),
            'from': 1,
            'to': count,
          },
        },
      }),
    );
  }

  @override
  Future<Result<BranchModel>> fetchBranch(int id) async {
    shows++;
    return Success<BranchModel>(BranchModel.fromJson(_branchJson(id: id)));
  }

  @override
  Future<Result<void>> createBranch(UpdateBranchRequestBody body) async {
    created.add(body.toJson());

    if (updateError != null) return Failure<void>(updateError!);
    return const Success<void>(null);
  }

  @override
  Future<Result<BranchModel>> updateBranch(
    int id,
    UpdateBranchRequestBody body,
  ) async {
    saved.add(<String, dynamic>{'id': id, ...body.toJson()});

    if (updateError != null) return Failure<BranchModel>(updateError!);

    final Map<String, dynamic> json = _branchJson(id: id);
    json['name'] = body.name;
    return Success<BranchModel>(BranchModel.fromJson(json));
  }

  @override
  Future<Result<void>> deleteBranch(int id) async {
    deleted.add(id);

    if (deleteError != null) return Failure<void>(deleteError!);
    return const Success<void>(null);
  }
}

class MenuRepo extends FakeLaboratoriesRepoBase {
  @override
  Future<Result<List<LaboratoryMenuItem>>> fetchLaboratoriesMenu({
    String search = '',
  }) async => const Success<List<LaboratoryMenuItem>>(<LaboratoryMenuItem>[
    LaboratoryMenuItem(id: 1, name: 'Lubowitz Lab'),
    LaboratoryMenuItem(id: 2, name: 'Champlin Lab'),
  ]);
}

Widget _app(BranchesCubit cubit) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: BlocProvider<BranchesCubit>.value(
        value: cubit,
        child: const BranchesView(),
      ),
    ),
  ),
);

Future<BranchesCubit> _open(WidgetTester tester, FakeBranchesRepo repo) async {
  final MenuRepo menu = MenuRepo();

  getIt.registerLazySingleton<LaboratoriesRepo>(() => menu);
  getIt.registerFactory<BranchDetailsCubit>(() => BranchDetailsCubit(repo));
  getIt.registerFactory<DeleteBranchCubit>(() => DeleteBranchCubit(repo));
  getIt.registerFactory<UpdateBranchCubit>(() => UpdateBranchCubit(repo, menu));
  addTearDown(() {
    getIt.unregister<LaboratoriesRepo>();
    getIt.unregister<BranchDetailsCubit>();
    getIt.unregister<DeleteBranchCubit>();
    getIt.unregister<UpdateBranchCubit>();
  });

  tester.view.physicalSize = const Size(1500, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final BranchesCubit cubit = BranchesCubit(repo)..load();
  addTearDown(cubit.close);

  await tester.pumpWidget(_app(cubit));
  await tester.pumpAndSettle();

  return cubit;
}

void main() {
  testWidgets('the list loads page 1 with per_page 10 and shows the rows', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    expect(repo.queries.single.toJson(), <String, dynamic>{
      'page': 1,
      'per_page': 10,
    });
    expect(find.text('Cairo branch'), findsOneWidget);
    expect(find.text('Giza branch'), findsOneWidget);
    expect(find.text('Lubowitz Lab'), findsNWidgets(2));
    expect(find.text('01095538077'), findsNWidgets(2));
    expect(find.text('Main'), findsOneWidget);
    expect(find.text('Showing 1 to 2 of 2 results'), findsOneWidget);
  });

  testWidgets('status and laboratory filters reach the query', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    final BranchesCubit cubit = await _open(tester, repo);

    await tester.tap(
      find.descendant(
        of: find.byType(AppSegmentedFilter<BranchStatusFilter>),
        matching: find.text('Inactive'),
      ),
    );
    await tester.pumpAndSettle();
    expect(repo.queries.last.toJson()['is_active'], 0);

    await cubit.changeLaboratory(2);
    await tester.pumpAndSettle();
    expect(repo.queries.last.toJson()['laboratory_id'], 2);

    await cubit.changeSearch('cairo');
    await tester.pumpAndSettle();
    expect(repo.queries.last.toJson()['search'], 'cairo');
    expect(repo.queries.last.page, 1);
  });

  testWidgets('the view action opens the details page', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(repo.shows, 1);
    expect(find.text('Back to branches'), findsOneWidget);
    expect(find.text('Cairo branch'), findsOneWidget);
    expect(find.text('test address'), findsOneWidget);
    expect(find.text('Both'), findsOneWidget);
    expect(find.text('Edit branch'), findsOneWidget);
  });

  testWidgets('editing sends every field and the kept phone id', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    expect(find.text('Edit branch'), findsWidgets);
    // The laboratory picker is filled from the menu endpoint, not the row.
    expect(find.text('Lubowitz Lab'), findsOneWidget);
    expect(find.text('Main branch'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Cairo main branch');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final Map<String, dynamic> body = repo.saved.single;
    expect(body['id'], 13);
    expect(body['name'], 'Cairo main branch');
    expect(body['laboratory_id'], 1);
    expect(body['is_main_branch'], true);
    expect(body['address'], 'test address');
    expect(body['lang'], 'en');
    expect((body['phones'] as List<dynamic>).single, <String, dynamic>{
      'id': 39,
      'phone': '01095538077',
      'phone_country': 'EG',
      'type': 'both',
    });

    expect(find.text('Branch saved'), findsOneWidget);
  });

  testWidgets('removing the only phone sends phones as null', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Remove this number'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(repo.saved.single['phones'], isNull);
  });

  testWidgets('a server error on save is shown on the field', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo(
      updateError: const AppError(
        kind: AppErrorKind.validation,
        statusCode: 422,
        message: 'Validation Error',
        fieldErrors: <String, List<String>>{
          'laboratory_id': <String>['The laboratory is not active.'],
        },
      ),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('The laboratory is not active.'), findsNWidgets(2));
    expect(find.text('Branch saved'), findsNothing);
  });

  testWidgets('the New branch button opens an empty create form', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New branch'));
    await tester.pumpAndSettle();

    expect(
      find.text('Add a branch to one of your laboratories.'),
      findsOneWidget,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      isEmpty,
    );

    // The laboratory is required, so saving without one is blocked.
    await tester.enterText(find.byType(TextField).first, 'New Cairo branch');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(repo.created, isEmpty);
  });

  testWidgets('creating posts the whole form without an id', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New branch'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'New Cairo branch');

    await tester.tap(find.byType(AppSelect<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lubowitz Lab').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created.single['name'], 'New Cairo branch');
    expect(repo.created.single['laboratory_id'], 1);
    expect(repo.created.single['lang'], 'en');
    expect(repo.created.single['phones'], isNull);
    expect(find.text('Branch created'), findsOneWidget);
  });

  testWidgets('deleting asks first, then refreshes with a notice', (
    WidgetTester tester,
  ) async {
    final FakeBranchesRepo repo = FakeBranchesRepo();
    await _open(tester, repo);

    final int before = repo.queries.length;

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Delete Cairo branch?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[13]);
    expect(find.text('Branch deleted'), findsOneWidget);
    expect(repo.queries.length, before + 1);
  });
}
