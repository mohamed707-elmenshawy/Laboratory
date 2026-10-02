import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/laboratories/UI/laboratory_logo_picker.dart';
import 'package:laboratory/laboratories/UI/laboratories_view.dart';
import 'package:laboratory/laboratories/UI/update_laboratory_view.dart';
import 'package:laboratory/laboratories/data/models/laboratories_page.dart';
import 'package:laboratory/laboratories/data/models/laboratories_query.dart';
import 'package:laboratory/laboratories/data/models/laboratory_model.dart';
import 'package:laboratory/laboratories/data/models/update_laboratory_request_body.dart';
import 'package:laboratory/laboratories/logic/laboratories_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_details_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_status_cubit.dart';
import 'package:laboratory/laboratories/logic/update_laboratory_cubit.dart';

import 'support/fake_laboratories_repo.dart';

const LaboratoryModel _laboratory = LaboratoryModel(
  id: 2,
  name: 'Laboratory 2',
  isActive: true,
  branchesCount: 1,
  logoUrl: 'https://laboratory.example/old.png',
);

final Uint8List _png = Uint8List.fromList(<int>[1, 2, 3, 4]);

final LaboratoryLogoFile _logo = LaboratoryLogoFile(
  bytes: _png,
  filename: 'logo.png',
);

class FakeLaboratoriesRepo extends FakeLaboratoriesRepoBase {
  FakeLaboratoriesRepo({this.error});

  final AppError? error;

  final List<(int, UpdateLaboratoryRequestBody)> updates =
      <(int, UpdateLaboratoryRequestBody)>[];

  @override
  Future<Result<LaboratoriesPage>> fetchLaboratories(
    LaboratoriesQuery query,
  ) async => Success<LaboratoriesPage>(
    LaboratoriesPage(
      items: const <LaboratoryModel>[_laboratory],
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
  Future<Result<LaboratoryModel>> fetchLaboratory(int id) async =>
      const Success<LaboratoryModel>(_laboratory);

  @override
  Future<Result<LaboratoryModel>> updateLaboratory(
    int id,
    UpdateLaboratoryRequestBody body,
  ) async {
    updates.add((id, body));

    if (error != null) return Failure<LaboratoryModel>(error!);

    return Success<LaboratoryModel>(
      LaboratoryModel(
        id: id,
        name: body.name,
        isActive: true,
        branchesCount: 1,
        logoUrl: body.logo == null
            ? _laboratory.logoUrl
            : 'https://laboratory.example/${body.logo!.filename}',
      ),
    );
  }
}

void _desktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  test('the update body is a multipart form with lang, name, and logo', () {
    final FormData form = UpdateLaboratoryRequestBody(
      lang: 'ar',
      name: 'المعمل الاول',
      logo: _logo,
    ).toFormData();

    expect(
      form.fields.map((MapEntry<String, String> field) => field.key),
      <String>['lang', 'name'],
    );
    expect(
      form.fields.map((MapEntry<String, String> field) => field.value),
      <String>['ar', 'المعمل الاول'],
    );
    expect(form.files.single.key, 'logo');
    expect(form.files.single.value.filename, 'logo.png');
  });

  test('a name-only update omits the logo file', () {
    final FormData form = const UpdateLaboratoryRequestBody(
      lang: 'en',
      name: 'Cairo Lab',
    ).toFormData();

    expect(form.files, isEmpty);
    expect(
      form.fields.map((MapEntry<String, String> field) => field.key),
      <String>['lang', 'name'],
    );
  });

  testWidgets('saving sends the trimmed name and chosen language', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();
    LaboratoryModel? saved;

    await tester.pumpWidget(
      _page(repo, onSaved: (LaboratoryModel laboratory) => saved = laboratory),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit laboratory'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Laboratory 2',
    );

    await tester.enterText(find.byType(TextField), '  Cairo Lab  ');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(repo.updates.single.$1, 2);
    expect(repo.updates.single.$2.lang, 'en');
    expect(repo.updates.single.$2.name, 'Cairo Lab');
    expect(repo.updates.single.$2.logo, isNull);
    expect(saved?.name, 'Cairo Lab');
  });

  testWidgets('picking Arabic and a logo sends both', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();

    await tester.pumpWidget(
      _page(
        repo,
        pickLogo: () async => LaboratoryLogoResult.picked(_logo),
        onSaved: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change logo'));
    await tester.pumpAndSettle();
    expect(find.text('logo.png'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'المعمل الاول');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final UpdateLaboratoryRequestBody body = repo.updates.single.$2;
    expect(body.lang, 'ar');
    expect(body.name, 'المعمل الاول');
    expect(body.logo?.filename, 'logo.png');
    expect(body.logo?.bytes, orderedEquals(<int>[1, 2, 3, 4]));
  });

  testWidgets('removing a chosen logo leaves the request without a file', (
    WidgetTester tester,
  ) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();

    await tester.pumpWidget(
      _page(
        repo,
        pickLogo: () async => LaboratoryLogoResult.picked(_logo),
        onSaved: (_) {},
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Change logo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove logo'));
    await tester.pumpAndSettle();

    expect(find.text('logo.png'), findsNothing);

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(repo.updates.single.$2.logo, isNull);
  });

  testWidgets('an empty name blocks the request', (WidgetTester tester) async {
    _desktop(tester);
    final FakeLaboratoriesRepo repo = FakeLaboratoriesRepo();

    await tester.pumpWidget(_page(repo, onSaved: (_) {}));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Enter the laboratory name.'), findsOneWidget);
    expect(repo.updates, isEmpty);
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
          'logo': <String>['The logo must be an image.'],
        },
      ),
    );

    await tester.pumpWidget(_page(repo, onSaved: (_) {}));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('The name field is required.'), findsOneWidget);
    expect(find.text('The logo must be an image.'), findsOneWidget);
    expect(find.text("Couldn't update the laboratory"), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Cairo Lab');
    await tester.pumpAndSettle();

    expect(find.text('The name field is required.'), findsNothing);
    expect(find.text('The logo must be an image.'), findsNothing);
  });

  testWidgets('saving from the list replaces the row and confirms it', (
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

    await tester.pumpWidget(
      AppLocaleScope(
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
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Cairo Lab');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(find.text('Laboratory updated'), findsOneWidget);
    expect(find.text('Cairo Lab'), findsOneWidget);
    expect(find.text('Edit laboratory'), findsNothing);
  });
}

Widget _page(
  FakeLaboratoriesRepo repo, {
  required ValueChanged<LaboratoryModel> onSaved,
  LaboratoryLogoPicker? pickLogo,
}) {
  getIt.registerFactory<LaboratoryDetailsCubit>(
    () => LaboratoryDetailsCubit(repo),
  );
  getIt.registerFactory<UpdateLaboratoryCubit>(
    () => UpdateLaboratoryCubit(repo),
  );
  addTearDown(() => getIt.unregister<LaboratoryDetailsCubit>());
  addTearDown(() => getIt.unregister<UpdateLaboratoryCubit>());

  return AppLocaleScope(
    child: MaterialApp(
      home: Scaffold(
        body: UpdateLaboratoryView.page(
          id: 2,
          onCancel: () {},
          onSaved: onSaved,
          pickLogo: pickLogo ?? () async => null,
        ),
      ),
    ),
  );
}
