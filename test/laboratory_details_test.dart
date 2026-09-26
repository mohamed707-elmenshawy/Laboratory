import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/laboratories/UI/laboratories_view.dart';
import 'package:laboratory/laboratories/data/models/laboratories_page.dart';
import 'package:laboratory/laboratories/data/models/laboratories_query.dart';
import 'package:laboratory/laboratories/data/models/laboratory_model.dart';
import 'package:laboratory/laboratories/logic/laboratories_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_details_cubit.dart';
import 'package:laboratory/laboratories/UI/widgets/laboratory_status_pill.dart';
import 'package:laboratory/laboratories/logic/laboratory_status_cubit.dart';

import 'support/fake_laboratories_repo.dart';

const LaboratoryModel _active = LaboratoryModel(
  id: 3,
  name: 'Laboratory 3',
  isActive: true,
  branchesCount: 2,
  admin: 'Tenant 3',
);

class FakeRepo extends FakeLaboratoriesRepoBase {
  FakeRepo({this.showError, this.statusError});

  final AppError? showError;
  final AppError? statusError;

  final List<int> shown = <int>[];
  final List<(int, bool)> statusCalls = <(int, bool)>[];
  LaboratoryModel laboratory = _active;

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async => Success<LaboratoriesPage>(
    LaboratoriesPage(
      items: <LaboratoryModel>[laboratory],
      pagination: const LaboratoriesPagination(
        total: 1,
        perPage: 10,
        currentPage: 1,
        lastPage: 1,
        from: 1,
        to: 1,
      ),
    ),
  );

  @override
  Future<Result<LaboratoryModel>> fetchLaboratory(int id) async {
    shown.add(id);

    if (showError != null) return Failure<LaboratoryModel>(showError!);
    return Success<LaboratoryModel>(laboratory);
  }

  @override
  Future<Result<LaboratoryModel>> setLaboratoryActive(
    int id,
    bool active,
  ) async {
    statusCalls.add((id, active));

    if (statusError != null) return Failure<LaboratoryModel>(statusError!);

    laboratory = LaboratoryModel(
      id: laboratory.id,
      name: laboratory.name,
      isActive: active,
      branchesCount: laboratory.branchesCount,
      admin: laboratory.admin,
    );
    return Success<LaboratoryModel>(laboratory);
  }
}

Widget _app(FakeRepo repo) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<LaboratoriesCubit>(
            create: (_) => LaboratoriesCubit(repo)..load(),
          ),
          BlocProvider<LaboratoryStatusCubit>(
            create: (_) => LaboratoryStatusCubit(repo),
          ),
        ],
        child: const LaboratoriesView(),
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester, FakeRepo repo) async {
  getIt.registerFactory<LaboratoryDetailsCubit>(
    () => LaboratoryDetailsCubit(repo),
  );
  getIt.registerFactory<LaboratoryStatusCubit>(
    () => LaboratoryStatusCubit(repo),
  );
  addTearDown(() => getIt.unregister<LaboratoryDetailsCubit>());
  addTearDown(() => getIt.unregister<LaboratoryStatusCubit>());

  tester.view.physicalSize = const Size(1400, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(_app(repo));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the view action opens the details page for that row', (
    WidgetTester tester,
  ) async {
    final FakeRepo repo = FakeRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View'));
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[3]);
    expect(find.text('Back to laboratories'), findsOneWidget);
    expect(find.text('Laboratory 3'), findsOneWidget);
    expect(find.text('3'), findsWidgets);
    expect(find.text('Tenant 3'), findsOneWidget);
    expect(find.text('Active'), findsWidgets);
    expect(find.text('Deactivate'), findsOneWidget);
  });

  testWidgets('deactivating from the details page updates the page', (
    WidgetTester tester,
  ) async {
    final FakeRepo repo = FakeRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Deactivate'));
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <(int, bool)>[(3, false)]);
    expect(find.text('Activate'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LaboratoryStatusPill),
        matching: find.text('Inactive'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('going back from details returns to the list', (
    WidgetTester tester,
  ) async {
    final FakeRepo repo = FakeRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to laboratories'));
    await tester.pumpAndSettle();

    expect(find.text('Laboratories'), findsWidgets);
    expect(find.text('Back to laboratories'), findsNothing);
  });

  testWidgets('a missing laboratory explains itself and can be retried', (
    WidgetTester tester,
  ) async {
    final FakeRepo repo = FakeRepo(
      showError: const AppError(kind: AppErrorKind.notFound, statusCode: 404),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View'));
    await tester.pumpAndSettle();

    expect(
      find.text('This laboratory is no longer there. Refresh the list.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[3, 3]);
  });

  testWidgets('the row toggle deactivates and updates the row in place', (
    WidgetTester tester,
  ) async {
    final FakeRepo repo = FakeRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Deactivate'));
    await tester.pumpAndSettle();

    expect(repo.statusCalls, <(int, bool)>[(3, false)]);
    expect(find.text('Laboratory deactivated'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LaboratoryStatusPill),
        matching: find.text('Inactive'),
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Activate'), findsOneWidget);
  });

  testWidgets('a failed status change is reported on the list', (
    WidgetTester tester,
  ) async {
    final FakeRepo repo = FakeRepo(
      statusError: const AppError(
        kind: AppErrorKind.forbidden,
        statusCode: 403,
        message: 'This action is unauthorized.',
      ),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Deactivate'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't change the laboratory status"), findsOneWidget);
    expect(find.text('This action is unauthorized.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LaboratoryStatusPill),
        matching: find.text('Active'),
      ),
      findsOneWidget,
    );
  });
}
