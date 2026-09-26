import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/laboratories/UI/create_laboratory_view.dart';
import 'package:laboratory/laboratories/data/models/create_laboratory_request_body.dart';
import 'package:laboratory/laboratories/data/models/laboratories_page.dart';
import 'package:laboratory/laboratories/data/models/laboratories_query.dart';

import 'support/fake_laboratories_repo.dart';
import 'package:laboratory/laboratories/logic/create_laboratory_cubit.dart';

class FakeLaboratoriesRepo extends FakeLaboratoriesRepoBase {
  FakeLaboratoriesRepo({this.error});

  final AppError? error;

  final List<Map<String, dynamic>> created = <Map<String, dynamic>>[];

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async => Success<LaboratoriesPage>(
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
    }),
  );

  @override
  Future<Result<void>> createLaboratory(
    CreateLaboratoryRequestBody body,
  ) async {
    created.add(body.toJson());

    if (error != null) return Failure<void>(error!);
    return const Success<void>(null);
  }
}

class _Harness extends StatelessWidget {
  const _Harness({required this.cubit, required this.onCreated});

  final CreateLaboratoryCubit cubit;
  final VoidCallback onCreated;

  @override
  Widget build(BuildContext context) => AppLocaleScope(
    settings: LabSettings.fallback,
    child: MaterialApp(
      home: Scaffold(
        body: BlocProvider<CreateLaboratoryCubit>.value(
          value: cubit,
          child: CreateLaboratoryView(onCancel: () {}, onCreated: onCreated),
        ),
      ),
    ),
  );
}

void _desktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

CreateLaboratoryCubit _cubit(FakeLaboratoriesRepo repo) {
  final CreateLaboratoryCubit cubit = CreateLaboratoryCubit(repo)
    ..start(AppLocale.en);
  addTearDown(cubit.close);
  return cubit;
}

void main() {
  testWidgets('the page sends the trimmed name with the chosen language', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    bool createdCalled = false;

    await tester.pumpWidget(
      _Harness(cubit: _cubit(repo), onCreated: () => createdCalled = true),
    );
    await tester.pumpAndSettle();

    expect(find.text('New laboratory'), findsOneWidget);
    expect(find.text('Back to laboratories'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '  Cairo Lab  ');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created.single, <String, dynamic>{
      'lang': 'en',
      'name': 'Cairo Lab',
    });
    expect(createdCalled, isTrue);
  });

  testWidgets('picking Arabic sends lang ar', (WidgetTester tester) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();

    await tester.pumpWidget(_Harness(cubit: _cubit(repo), onCreated: () {}));
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'معمل القاهرة');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created.single, <String, dynamic>{
      'lang': 'ar',
      'name': 'معمل القاهرة',
    });
  });

  testWidgets('an empty name blocks the request', (WidgetTester tester) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();

    await tester.pumpWidget(_Harness(cubit: _cubit(repo), onCreated: () {}));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Enter the laboratory name.'), findsOneWidget);
    expect(repo.created, isEmpty);
  });

  testWidgets('a server error is shown and clears when the name changes', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo(
      error: const AppError(
        kind: AppErrorKind.validation,
        statusCode: 422,
        message: 'Validation Error',
        fieldErrors: <String, List<String>>{
          'name': <String>['The name field is required.'],
        },
      ),
    );
    bool createdCalled = false;

    await tester.pumpWidget(
      _Harness(cubit: _cubit(repo), onCreated: () => createdCalled = true),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Cairo Lab');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('The name field is required.'), findsOneWidget);
    expect(createdCalled, isFalse);

    await tester.enterText(find.byType(TextField), 'Cairo Lab 2');
    await tester.pumpAndSettle();

    expect(find.text('The name field is required.'), findsNothing);

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(repo.created.length, 2);
  });
}
