import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/register/UI/widgets/register_terms_checkbox.dart';
import 'package:laboratory/register/data/models/register_request_body.dart';
import 'package:laboratory/register/data/models/register_response.dart';
import 'package:laboratory/register/data/repos/register_repo.dart';
import 'package:laboratory/register/logic/register_cubit.dart';
import 'package:laboratory/terms/data/models/term_model.dart';
import 'package:laboratory/terms/data/repos/terms_repo.dart';
import 'package:laboratory/terms/logic/terms_cubit.dart';

const List<TermModel> _terms = <TermModel>[
  TermModel(
    id: 1,
    name: 'Privacy',
    description: 'We keep your data safe.',
    isActive: true,
  ),
  TermModel(
    id: 2,
    name: 'Payments',
    description: 'Invoices are due in 30 days.',
    isActive: true,
  ),
];

class FakeTermsRepo implements TermsRepo {
  FakeTermsRepo({this.failFirst = false});

  bool failFirst;
  int calls = 0;

  @override
  Future<Result<List<TermModel>>> fetchTerms() async {
    calls++;
    if (failFirst) {
      failFirst = false;
      return const Failure<List<TermModel>>(
        AppError(kind: AppErrorKind.network),
      );
    }
    return const Success<List<TermModel>>(_terms);
  }
}

class FakeRegisterRepo implements RegisterRepo {
  @override
  Future<Result<RegisterResponse>> register(RegisterRequestBody body) async =>
      Success<RegisterResponse>(RegisterResponse(email: body.email));
}

Widget _harness(RegisterCubit cubit) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: BlocProvider<RegisterCubit>.value(
        value: cubit,
        child: const Form(child: RegisterTermsCheckbox()),
      ),
    ),
  ),
);

void main() {
  late FakeTermsRepo repo;

  setUp(() {
    repo = FakeTermsRepo();
    getIt.registerFactory<TermsCubit>(() => TermsCubit(repo));
  });

  tearDown(getIt.reset);

  test('parses the terms list payload', () {
    final TermModel term = TermModel.fromJson(const <String, dynamic>{
      'id': 4,
      'name': 'enim ducimus Terms',
      'description': 'Corporis sit repellat vero voluptates.',
      'is_active': true,
    });

    expect(term.id, 4);
    expect(term.name, 'enim ducimus Terms');
    expect(term.description, 'Corporis sit repellat vero voluptates.');
    expect(term.isActive, isTrue);
  });

  testWidgets('the terms link opens a popup with names and descriptions', (
    WidgetTester tester,
  ) async {
    final RegisterCubit cubit = RegisterCubit(FakeRegisterRepo());
    addTearDown(cubit.close);

    await tester.pumpWidget(_harness(cubit));
    await tester.tap(find.text('Terms and Conditions'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Privacy'), findsOneWidget);
    expect(find.text('We keep your data safe.'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Invoices are due in 30 days.'), findsOneWidget);
    expect(cubit.acceptedTerms, isFalse);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('a failed load shows retry, and retry loads the terms', (
    WidgetTester tester,
  ) async {
    repo.failFirst = true;
    final RegisterCubit cubit = RegisterCubit(FakeRegisterRepo());
    addTearDown(cubit.close);

    await tester.pumpWidget(_harness(cubit));
    await tester.tap(find.text('Terms and Conditions'));
    await tester.pumpAndSettle();

    expect(find.text('Privacy'), findsNothing);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(repo.calls, 2);
    expect(find.text('Privacy'), findsOneWidget);
  });
}
