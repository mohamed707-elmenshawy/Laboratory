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

import 'support/fake_laboratories_repo.dart';
import 'package:laboratory/laboratories/logic/delete_laboratory_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratories_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_status_cubit.dart';

class FakeLaboratoriesRepo extends FakeLaboratoriesRepoBase {
  FakeLaboratoriesRepo({this.deleteError});

  final AppError? deleteError;

  int listCalls = 0;
  final List<int> deleted = <int>[];

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async {
    listCalls++;

    return Success<LaboratoriesPage>(
      LaboratoriesPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 3,
            'name': 'Laboratory 3',
            'is_active': true,
            'branches_count': 0,
            'admin': 'Tenant 3',
          },
          <String, dynamic>{
            'id': 2,
            'name': 'Laboratory 2',
            'is_active': true,
            'branches_count': 2,
            'admin': 'Tenant 2',
          },
        ],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': 2,
            'per_page': 10,
            'current_page': 1,
            'last_page': 1,
            'from': 1,
            'to': 2,
          },
        },
      }),
    );
  }

  @override
  Future<Result<void>> deleteLaboratory(int id) async {
    deleted.add(id);

    if (deleteError != null) return Failure<void>(deleteError!);
    return const Success<void>(null);
  }
}

Widget _app(LaboratoriesCubit cubit, FakeLaboratoriesRepo repo) =>
    AppLocaleScope(
      child: MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<LaboratoriesCubit>.value(value: cubit),
              BlocProvider<LaboratoryStatusCubit>(
                create: (_) => LaboratoryStatusCubit(repo),
              ),
            ],
            child: const LaboratoriesView(),
          ),
        ),
      ),
    );

void _desktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1400, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<LaboratoriesCubit> _open(
  WidgetTester tester,
  FakeLaboratoriesRepo repo,
) async {
  getIt.registerFactory<DeleteLaboratoryCubit>(
    () => DeleteLaboratoryCubit(repo),
  );
  addTearDown(() => getIt.unregister<DeleteLaboratoryCubit>());

  final LaboratoriesCubit cubit = LaboratoriesCubit(repo)..load();
  addTearDown(cubit.close);

  _desktop(tester);
  await tester.pumpWidget(_app(cubit, repo));
  await tester.pumpAndSettle();

  return cubit;
}

void main() {
  testWidgets('confirming sends the delete and refreshes the list', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    await _open(tester, repo);

    final int listCallsBefore = repo.listCalls;

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Delete Laboratory 3?'), findsOneWidget);
    expect(
      find.text('It moves to the trash, so an admin can still restore it.'),
      findsOneWidget,
    );
    expect(find.text('Its branches go with it'), findsNothing);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[3]);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Laboratory deleted'), findsOneWidget);
    expect(repo.listCalls, listCallsBefore + 1);
  });

  testWidgets('a laboratory with branches warns that they go too', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').last);
    await tester.pumpAndSettle();

    expect(find.text('Delete Laboratory 2?'), findsOneWidget);
    expect(find.text('Its branches go with it'), findsOneWidget);
    expect(
      find.text('All 2 branches in this laboratory are deleted too.'),
      findsOneWidget,
    );
  });

  testWidgets('cancelling closes the dialog and deletes nothing', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(repo.deleted, isEmpty);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Laboratory deleted'), findsNothing);
  });

  testWidgets('a server error keeps the dialog open with the reason', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo(
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
    expect(find.text("Couldn't delete the laboratory"), findsOneWidget);
    expect(find.text('This action is unauthorized.'), findsOneWidget);
    expect(find.text('Laboratory deleted'), findsNothing);
  });

  testWidgets('a 404 explains the laboratory is already gone', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo(
      deleteError: const AppError(
        kind: AppErrorKind.notFound,
        statusCode: 404,
        message: 'Not Found',
      ),
    );
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(
      find.text('This laboratory is no longer there. Refresh the list.'),
      findsOneWidget,
    );
  });
}
