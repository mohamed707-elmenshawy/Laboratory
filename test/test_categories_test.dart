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
import 'package:laboratory/test_categories/UI/test_categories_view.dart';
import 'package:laboratory/test_categories/data/models/test_categories_page.dart';
import 'package:laboratory/test_categories/data/models/test_categories_query.dart';
import 'package:laboratory/test_categories/data/models/test_category_model.dart';
import 'package:laboratory/test_categories/data/models/test_category_request_body.dart';
import 'package:laboratory/test_categories/data/repos/test_categories_repo.dart';
import 'package:laboratory/test_categories/logic/delete_test_category_cubit.dart';
import 'package:laboratory/test_categories/logic/test_categories_cubit.dart';
import 'package:laboratory/test_categories/logic/test_category_status_cubit.dart';
import 'package:laboratory/test_categories/logic/test_category_details_cubit.dart';
import 'package:laboratory/test_categories/logic/test_category_form_cubit.dart';

import 'support/fake_laboratories_repo.dart';

Map<String, dynamic> _categoryJson({
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

class FakeTestCategoriesRepo implements TestCategoriesRepo {
  FakeTestCategoriesRepo({this.showError, this.deleteError, this.statusError});

  final AppError? showError;
  final AppError? deleteError;
  final AppError? statusError;

  final List<Map<String, Object>> statusCalls = <Map<String, Object>>[];

  final List<TestCategoriesQuery> queries = <TestCategoriesQuery>[];
  final List<int> shown = <int>[];
  final List<int> deleted = <int>[];
  final List<Map<String, dynamic>> created = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> saved = <Map<String, dynamic>>[];

  @override
  Future<Result<TestCategoriesPage>> fetchTestCategories(
    TestCategoriesQuery query,
  ) async {
    queries.add(query);

    return Success<TestCategoriesPage>(
      TestCategoriesPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          _categoryJson(),
          _categoryJson(
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
  Future<Result<TestCategoryModel>> fetchTestCategory(int id) async {
    shown.add(id);

    if (showError != null) return Failure<TestCategoryModel>(showError!);
    return Success<TestCategoryModel>(
      TestCategoryModel.fromJson(_categoryJson(id: id)),
    );
  }

  @override
  Future<Result<void>> createTestCategory(TestCategoryRequestBody body) async {
    created.add(body.toJson());
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> updateTestCategory(
    int id,
    TestCategoryRequestBody body,
  ) async {
    saved.add(<String, dynamic>{'id': id, ...body.toJson()});
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> deleteTestCategory(int id) async {
    deleted.add(id);

    if (deleteError != null) return Failure<void>(deleteError!);
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> setTestCategoryActive(int id, bool active) async {
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

Widget _app(TestCategoriesCubit cubit, TestCategoryStatusCubit status) =>
    AppLocaleScope(
      child: MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<TestCategoriesCubit>.value(value: cubit),
              BlocProvider<TestCategoryStatusCubit>.value(value: status),
            ],
            child: const TestCategoriesView(),
          ),
        ),
      ),
    );

Future<void> _open(WidgetTester tester, FakeTestCategoriesRepo repo) async {
  getIt.registerLazySingleton<LaboratoriesRepo>(MenuRepo.new);
  getIt.registerFactory<TestCategoryDetailsCubit>(
    () => TestCategoryDetailsCubit(repo),
  );
  getIt.registerFactory<DeleteTestCategoryCubit>(
    () => DeleteTestCategoryCubit(repo),
  );
  getIt.registerFactory<TestCategoryFormCubit>(
    () => TestCategoryFormCubit(repo, MenuRepo(), FakeBranchesRepo()),
  );
  addTearDown(() {
    getIt.unregister<LaboratoriesRepo>();
    getIt.unregister<TestCategoryDetailsCubit>();
    getIt.unregister<DeleteTestCategoryCubit>();
    getIt.unregister<TestCategoryFormCubit>();
  });

  tester.view.physicalSize = const Size(1500, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final TestCategoriesCubit cubit = TestCategoriesCubit(repo)..load();
  addTearDown(cubit.close);

  final TestCategoryStatusCubit status = TestCategoryStatusCubit(repo);
  addTearDown(status.close);

  await tester.pumpWidget(_app(cubit, status));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the list asks for page 1 with per_page 10 and renders rows', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
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

  testWidgets('the row toggle activates that category and only that one', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Activate').first);
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <Map<String, Object>>[
      <String, Object>{'id': 5, 'active': true},
    ]);
    expect(find.text('Category activated'), findsOneWidget);
  });

  testWidgets('the toggle of the second row carries its own id', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Deactivate').first);
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <Map<String, Object>>[
      <String, Object>{'id': 3, 'active': false},
    ]);
    expect(find.text('Category deactivated'), findsOneWidget);
  });

  testWidgets('status and laboratory filters reach the query', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(
      find.descendant(
        of: find.byType(AppSegmentedFilter<TestCategoryStatusFilter>),
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
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[5]);
    expect(find.text('Back to test categories'), findsOneWidget);
    expect(find.text('Gerlach Ltd'), findsOneWidget);
    expect(find.text('Quality-focused superstructure'), findsOneWidget);
    expect(find.text('Zemlak-Pollich'), findsOneWidget);
  });

  testWidgets('a missing category explains itself and retries', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo(
      showError: const AppError(kind: AppErrorKind.notFound, statusCode: 404),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(
      find.text('This category is no longer there. Refresh the list.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(repo.shown, <int>[5, 5]);
  });

  testWidgets('deleting from the list asks first, then refreshes', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
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
    expect(find.text('Category deleted'), findsOneWidget);
    expect(repo.queries.length, before + 1);
  });

  testWidgets('cancelling the delete changes nothing', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repo.deleted, isEmpty);
    expect(find.text('Category deleted'), findsNothing);
  });

  testWidgets('a failed delete keeps the dialog open with the reason', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo(
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
    expect(find.text('Category deleted'), findsNothing);
  });

  testWidgets('deleting from the details page returns to the list', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppButton, 'Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[5]);
    expect(find.text('Back to test categories'), findsNothing);
    expect(find.text('Category deleted'), findsOneWidget);
  });

  testWidgets('creating posts every field without an id', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New category'));
    await tester.pumpAndSettle();

    expect(
      find.text('Add a category to a branch of one of your laboratories.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).first, 'Haematology');
    await tester.enterText(find.byType(TextField).at(1), 'Blood work');

    // The laboratory must be picked before the branch list arrives.
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
    expect(find.text('Category created'), findsOneWidget);
  });

  testWidgets('create blocks until a laboratory and branch are chosen', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New category'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Haematology');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created, isEmpty);
  });

  testWidgets('editing prefills the row and posts to its id', (
    WidgetTester tester,
  ) async {
    final FakeTestCategoriesRepo repo = FakeTestCategoriesRepo();
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
    expect(find.text('Category saved'), findsOneWidget);
  });
}
