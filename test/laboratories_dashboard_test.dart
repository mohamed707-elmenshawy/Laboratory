import 'dart:async';

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
import 'package:laboratory/laboratories/UI/widgets/laboratories_table.dart';
import 'package:laboratory/laboratories/UI/widgets/laboratories_toolbar.dart';
import 'package:laboratory/laboratories/data/models/laboratory_model.dart';
import 'package:laboratory/laboratories/logic/create_laboratory_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratories_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_details_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_status_cubit.dart';
import 'package:laboratory/laboratories/logic/update_laboratory_cubit.dart';

class FakeLaboratoriesRepo extends FakeLaboratoriesRepoBase {
  FakeLaboratoriesRepo({this.total = 23, this.error, this.noMatch = 'zzz'});

  final int total;

  // A search for this term matches nothing.
  final String noMatch;
  final AppError? error;

  final List<LaboratoriesQuery> calls = <LaboratoriesQuery>[];

  @override
  Future<Result<LaboratoryModel>> fetchLaboratory(int id) async =>
      Success<LaboratoryModel>(
        LaboratoryModel(
          id: id,
          name: 'Laboratory $id',
          isActive: id.isEven,
          branchesCount: 0,
          logoUrl: 'https://laboratory.example/logo.png',
        ),
      );

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async {
    calls.add(query);

    if (error != null) return Failure<LaboratoriesPage>(error!);

    final int total = query.search == noMatch ? 0 : this.total;
    final int lastPage = total == 0 ? 1 : (total / query.pageSize).ceil();
    final int start = (query.page - 1) * query.pageSize;
    final int count = start >= total
        ? 0
        : (start + query.pageSize > total ? total - start : query.pageSize);

    return Success<LaboratoriesPage>(
      LaboratoriesPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          for (int i = 0; i < count; i++)
            <String, dynamic>{
              'id': total - start - i,
              'name': 'Laboratory ${total - start - i}',
              'is_active': (total - start - i).isEven,
              'branches_count': 100 + i,
              'admin': i == 0 ? null : 'Tenant ${total - start - i}',
            },
        ],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': total,
            'per_page': query.pageSize,
            'current_page': query.page,
            'last_page': lastPage,
            'from': count == 0 ? null : start + 1,
            'to': count == 0 ? null : start + count,
          },
        },
      }),
    );
  }
}

Widget _app(FakeLaboratoriesRepoBase repo) => AppLocaleScope(
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

void _desktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1400, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Finder _inTable(String text) => find.descendant(
  of: find.byType(LaboratoriesTable),
  matching: find.text(text),
);

Finder _segment(String label) => find.descendant(
  of: find.byType(LaboratoriesStatusFilter),
  matching: find.text(label),
);

Finder get _searchInput => find.descendant(
  of: find.byType(LaboratoriesSearchField),
  matching: find.byType(TextField),
);

void main() {
  test('query sends search and is_active only when set', () {
    expect(
      const LaboratoriesQuery(page: 1, pageSize: 10).toJson(),
      <String, dynamic>{'page': 1, 'page_size': 10},
    );
    expect(
      const LaboratoriesQuery(
        page: 2,
        pageSize: 25,
        search: 'Lab',
        status: LaboratoryStatusFilter.active,
      ).toJson(),
      <String, dynamic>{
        'page': 2,
        'page_size': 25,
        'search': 'Lab',
        'is_active': 1,
      },
    );
    expect(
      const LaboratoriesQuery(
        page: 1,
        pageSize: 10,
        status: LaboratoryStatusFilter.inactive,
      ).toJson()['is_active'],
      0,
    );
  });

  testWidgets('typing searches by name after a pause and resets to page 1', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    expect(repo.calls.length, 2);

    await tester.enterText(_searchInput, 'Lab');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(_searchInput, '  Laboratory 1 ');
    await tester.pump(const Duration(milliseconds: 100));

    // Still inside the debounce window: nothing sent yet.
    expect(repo.calls.length, 2);

    await tester.pump(LaboratoriesSearchField.debounce);
    await tester.pumpAndSettle();

    expect(repo.calls.length, 3);
    expect(repo.calls.last.toJson(), <String, dynamic>{
      'page': 1,
      'page_size': 10,
      'search': 'Laboratory 1',
    });
  });

  testWidgets('enter searches immediately and the clear button resets it', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.enterText(_searchInput, 'Lab');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(repo.calls.last.search, 'Lab');
    expect(repo.calls.length, 2);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();

    expect(repo.calls.length, 3);
    expect(repo.calls.last.toJson().containsKey('search'), isFalse);
    expect(find.byTooltip('Clear search'), findsNothing);
  });

  testWidgets('status filter sends is_active and resets to page 1', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    await tester.tap(_segment('Active'));
    await tester.pumpAndSettle();
    expect(repo.calls.last.toJson(), <String, dynamic>{
      'page': 1,
      'page_size': 10,
      'is_active': 1,
    });

    await tester.tap(_segment('Inactive'));
    await tester.pumpAndSettle();
    expect(repo.calls.last.toJson()['is_active'], 0);

    final int before = repo.calls.length;
    await tester.tap(_segment('Inactive'));
    await tester.pumpAndSettle();
    expect(repo.calls.length, before, reason: 'reselecting is a no-op');

    await tester.tap(_segment('All'));
    await tester.pumpAndSettle();
    expect(repo.calls.last.toJson().containsKey('is_active'), isFalse);
  });

  testWidgets('no matches offers to clear every filter', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(_segment('Active'));
    await tester.pumpAndSettle();
    await tester.enterText(_searchInput, 'zzz');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('No matching laboratories'), findsOneWidget);
    expect(find.text('No laboratories yet'), findsNothing);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();

    expect(repo.calls.last.toJson(), <String, dynamic>{
      'page': 1,
      'page_size': 10,
    });
    expect(tester.widget<TextField>(_searchInput).controller!.text, isEmpty);
    expect(find.text('Showing 1 to 10 of 23 results'), findsOneWidget);
  });

  test(
    'a slow response for an older search never overwrites a newer one',
    () async {
      final _ControlledRepo repo = _ControlledRepo();
      final LaboratoriesCubit cubit = LaboratoriesCubit(repo);
      addTearDown(cubit.close);

      final Future<void> first = cubit.changeSearch('a');
      final Future<void> second = cubit.changeSearch('ab');

      repo.complete('ab', total: 1);
      await second;
      repo.complete('a', total: 5);
      await first;

      final LaboratoriesState state = cubit.state;
      expect(state, isA<LaboratoriesLoaded>());
      expect((state as LaboratoriesLoaded).page.pagination.total, 1);
    },
  );

  testWidgets('first load asks for page 1 with page_size 10', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(repo.calls.single.toJson(), <String, dynamic>{
      'page': 1,
      'page_size': 10,
    });
    expect(find.text('Laboratory 23'), findsOneWidget);
    expect(find.text('Laboratory 14'), findsOneWidget);
    expect(find.text('Laboratory 13'), findsNothing);
    expect(find.text('Showing 1 to 10 of 23 results'), findsOneWidget);
    expect(_inTable('Active'), findsNWidgets(5));
    expect(_inTable('Inactive'), findsNWidgets(5));
    expect(find.text('Not assigned'), findsOneWidget);
  });

  testWidgets('page buttons and arrows move between pages', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    expect(repo.calls.last.toJson(), <String, dynamic>{
      'page': 3,
      'page_size': 10,
    });
    expect(find.text('Showing 21 to 23 of 23 results'), findsOneWidget);
    expect(find.text('Laboratory 3'), findsOneWidget);

    await tester.tap(find.byTooltip('Previous page'));
    await tester.pumpAndSettle();

    expect(repo.calls.last.page, 2);
    expect(find.text('Showing 11 to 20 of 23 results'), findsOneWidget);

    await tester.tap(find.byTooltip('Next page'));
    await tester.pumpAndSettle();

    expect(repo.calls.last.page, 3);
  });

  testWidgets('changing per page resets to page 1 and refetches', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    expect(repo.calls.last.page, 2);

    await tester.tap(find.byType(DropdownButton<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('25').last);
    await tester.pumpAndSettle();

    expect(repo.calls.last.toJson(), <String, dynamic>{
      'page': 1,
      'page_size': 25,
    });
    expect(find.text('Showing 1 to 23 of 23 results'), findsOneWidget);
  });

  testWidgets('a page past the end falls back to the last page', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();

    final LaboratoriesCubit cubit = tester
        .element(find.byType(LaboratoriesView))
        .read<LaboratoriesCubit>();

    await cubit.goToPage(9);
    await tester.pumpAndSettle();

    expect(repo.calls.map((LaboratoriesQuery q) => q.page).toList(), <int>[
      1,
      3,
      9,
      3,
    ]);
    expect(find.text('Showing 21 to 23 of 23 results'), findsOneWidget);
  });

  testWidgets('empty state shows when there are no laboratories', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    await tester.pumpWidget(_app(FakeLaboratoriesRepo(total: 0)));
    await tester.pumpAndSettle();

    expect(find.text('No laboratories yet'), findsOneWidget);
    expect(find.text('No results'), findsOneWidget);
  });

  testWidgets('failure shows the alert and retry refetches', (
    WidgetTester tester,
  ) async {
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo(
      error: const AppError(kind: AppErrorKind.network),
    );
    _desktop(tester);
    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    expect(find.text("Can’t reach the server"), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(repo.calls.length, 2);
  });

  testWidgets('the edit action opens the page with the row prefilled', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    getIt.registerFactory<LaboratoryDetailsCubit>(
      () => LaboratoryDetailsCubit(repo),
    );
    getIt.registerFactory<UpdateLaboratoryCubit>(
      () => UpdateLaboratoryCubit(repo),
    );
    addTearDown(() => getIt.unregister<LaboratoryDetailsCubit>());
    addTearDown(() => getIt.unregister<UpdateLaboratoryCubit>());

    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    expect(find.text('Edit laboratory'), findsOneWidget);
    expect(find.text('Logo'), findsOneWidget);
    expect(find.text('Not connected yet'), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      'Laboratory 23',
    );

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Edit laboratory'), findsNothing);
  });

  testWidgets('the create button opens the create page', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    getIt.registerFactory<CreateLaboratoryCubit>(
      () => CreateLaboratoryCubit(repo),
    );
    addTearDown(() => getIt.unregister<CreateLaboratoryCubit>());

    await tester.pumpWidget(_app(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New laboratory'));
    await tester.pumpAndSettle();

    expect(find.text('Back to laboratories'), findsOneWidget);
    expect(find.text('Laboratory name'), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });
}

class _ControlledRepo extends FakeLaboratoriesRepoBase {
  final Map<String, Completer<Result<LaboratoriesPage>>> _pending =
      <String, Completer<Result<LaboratoriesPage>>>{};

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(LaboratoriesQuery query) {
    return (_pending[query.search] = Completer<Result<LaboratoriesPage>>())
        .future;
  }

  void complete(String search, {required int total}) {
    _pending[search]!.complete(
      Success<LaboratoriesPage>(
        LaboratoriesPage.fromJson(<String, dynamic>{
          'items': <Map<String, dynamic>>[
            <String, dynamic>{'id': 1, 'name': search, 'is_active': true},
          ],
          'pagination': <String, dynamic>{
            'meta': <String, dynamic>{
              'total': total,
              'per_page': 10,
              'current_page': 1,
              'last_page': 1,
            },
          },
        }),
      ),
    );
  }
}
