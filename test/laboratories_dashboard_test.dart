import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/laboratories/UI/laboratories_view.dart';
import 'package:laboratory/laboratories/data/models/laboratories_page.dart';
import 'package:laboratory/laboratories/data/models/laboratories_query.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';
import 'package:laboratory/laboratories/logic/laboratories_cubit.dart';

class FakeLaboratoriesRepo implements LaboratoriesRepo {
  FakeLaboratoriesRepo({this.total = 23, this.error});

  final int total;
  final AppError? error;

  final List<LaboratoriesQuery> calls = <LaboratoriesQuery>[];

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async {
    calls.add(query);

    if (error != null) return Failure<LaboratoriesPage>(error!);

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

Widget _app(LaboratoriesRepo repo) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: BlocProvider<LaboratoriesCubit>(
        create: (_) => LaboratoriesCubit(repo)..load(),
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

void main() {
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
    expect(find.text('Active'), findsNWidgets(5));
    expect(find.text('Inactive'), findsNWidgets(5));
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

  testWidgets('row actions open the view, edit and delete dialogs', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    await tester.pumpWidget(_app(FakeLaboratoriesRepo()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();
    expect(find.text('Laboratory details'), findsOneWidget);
    expect(find.text('Laboratory 23'), findsNWidgets(2));
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();
    expect(find.text('Edit laboratory'), findsOneWidget);
    expect(find.text('Not connected yet'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Laboratory 23',
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();
    expect(find.text('Delete laboratory'), findsOneWidget);
    expect(
      find.text('Delete Laboratory 23? This cannot be undone.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('New laboratory'));
    await tester.pumpAndSettle();
    expect(find.text('New laboratory'), findsNWidgets(2));
  });
}
