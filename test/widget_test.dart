import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/core/ui/ui.dart';
import 'package:laboratory/login/UI/login_screen.dart';
import 'package:laboratory/login/data/repos/login_repo.dart';
import 'package:laboratory/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_login_data_source.dart';

void main() {
  const AppStrings en = AppStringsEn();
  const AppStrings ar = AppStringsAr();

  const Size expandedSurface = Size(1400, 900);
  const Size mediumSurface = Size(800, 900);
  const double testFontCompensation = 0.7;

  late FakeLoginDataSource dataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dataSource = FakeLoginDataSource();
  });

  Future<void> submit(WidgetTester tester) async {
    await tester.tap(find.byType(AppButton));
    await tester.pump();
    await tester.pump();
  }

  Future<void> fillForm(
    WidgetTester tester, {
    String email = 'admin@email.com',
    String password = 'password',
  }) async {
    await tester.enterText(find.byType(TextField).first, email);
    await tester.enterText(find.byType(TextField).last, password);
    await tester.pump();
  }

  Future<void> pumpSignIn(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MediaQuery.withClampedTextScaling(
        maxScaleFactor: testFontCompensation,
        child: LaboratoryApp(loginRepo: LoginRepo(dataSource)),
      ),
    );
    await tester.pumpAndSettle();
  }

  bool hasFocus(WidgetTester tester, Finder field) =>
      tester.widget<TextField>(field).focusNode!.hasFocus;

  testWidgets('renders the sign-in form in English by default', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);

    expect(find.text(en.signInTitle), findsWidgets);
    expect(find.text(en.signInSubtitle), findsOneWidget);
    expect(find.text(en.emailLabel), findsOneWidget);
    expect(find.text(en.passwordLabel), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(LoginScreen))),
      TextDirection.ltr,
    );
  });

  testWidgets('the language switcher re-renders the form in Arabic and RTL', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);

    await tester.tap(find.text(AppLocale.ar.nativeName));
    await tester.pumpAndSettle();

    expect(find.text(ar.signInSubtitle), findsOneWidget);
    expect(find.text(ar.signInTitle), findsWidgets);
    expect(find.text(en.signInSubtitle), findsNothing);

    expect(
      Directionality.of(tester.element(find.byType(LoginScreen))),
      TextDirection.rtl,
    );
  });

  testWidgets('the brand pane is mounted at the expanded breakpoint', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);

    expect(find.text(en.brandStatement), findsOneWidget);
  });

  testWidgets('the brand pane is dropped below the expanded breakpoint', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: mediumSurface);

    expect(find.text(en.brandStatement), findsNothing);
    expect(find.text(en.emailLabel), findsOneWidget);
    expect(find.text(en.passwordLabel), findsOneWidget);
  });

  testWidgets('a blank submit shows both required errors and no spinner', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await submit(tester);

    expect(find.text(en.emailRequired), findsOneWidget);
    expect(find.text(en.passwordRequired), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(dataSource.callCount, 0);
  });

  testWidgets('a malformed email is reported under the field', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester, email: 'nope');
    await submit(tester);

    expect(find.text(en.emailInvalid), findsOneWidget);
    expect(dataSource.callCount, 0);
  });

  testWidgets('a rejected credential shows one form-level alert', (
    WidgetTester tester,
  ) async {
    dataSource.error = httpFailure(401, badCredentialsBody);

    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await submit(tester);
    await tester.pumpAndSettle();

    expect(find.text(en.feedbackAuthTitle), findsOneWidget);
    expect(
      find.text('These credentials do not match our records.'),
      findsOneWidget,
    );
    expect(find.text(en.emailRequired), findsNothing);
  });

  testWidgets('an unverified account offers the verify action', (
    WidgetTester tester,
  ) async {
    dataSource.error = httpFailure(403, unverifiedBody);

    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await submit(tester);
    await tester.pumpAndSettle();

    expect(find.text(en.feedbackAccountTitle), findsOneWidget);
    expect(find.text(en.verifyEmailAction), findsOneWidget);
  });

  testWidgets('a throttled form disables its submit button', (
    WidgetTester tester,
  ) async {
    dataSource.error = httpFailure(429, rateLimitedBody);

    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await submit(tester);

    expect(find.text(en.feedbackRateLimitTitle), findsOneWidget);
    expect(tester.widget<AppButton>(find.byType(AppButton)).onPressed, isNull);
  });

  testWidgets('a successful sign-in reports the account', (
    WidgetTester tester,
  ) async {
    dataSource.response = successResponse(name: 'Super Admin');

    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await submit(tester);
    await tester.pumpAndSettle();

    expect(find.text(en.feedbackSuccessTitle), findsWidgets);
    expect(find.text(en.signedInAs('Super Admin')), findsOneWidget);
    expect(tester.widget<AppButton>(find.byType(AppButton)).isSuccess, isTrue);
    expect(dataSource.lastBody!.email, 'admin@email.com');
  });

  testWidgets('field errors follow a language change', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await submit(tester);
    expect(find.text(en.emailRequired), findsOneWidget);

    await tester.tap(find.text(AppLocale.ar.nativeName));
    await tester.pumpAndSettle();

    expect(find.text(en.emailRequired), findsNothing);
    expect(find.text(ar.emailRequired), findsOneWidget);
    expect(find.text(ar.passwordRequired), findsOneWidget);
  });

  testWidgets('the email field hands focus to the password field', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);

    await tester.showKeyboard(find.byType(TextField).first);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();

    expect(hasFocus(tester, find.byType(TextField).first), isFalse);
    expect(hasFocus(tester, find.byType(TextField).last), isTrue);
  });

  testWidgets('a blank submit focuses the email field', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await submit(tester);
    await tester.pump();

    expect(hasFocus(tester, find.byType(TextField).first), isTrue);
  });

  testWidgets('a missing password alone focuses the password field', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await tester.enterText(find.byType(TextField).first, 'admin@email.com');
    await tester.pump();
    await submit(tester);
    await tester.pump();

    expect(find.text(en.passwordRequired), findsOneWidget);
    expect(hasFocus(tester, find.byType(TextField).last), isTrue);
  });

  testWidgets('typed credentials survive a breakpoint change', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester, email: 'kept@email.com', password: 'secret');

    tester.view.physicalSize = mediumSurface;
    await tester.pumpAndSettle();

    expect(find.text(en.brandStatement), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'kept@email.com',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      'secret',
    );
  });

  testWidgets('remember me persists the session', (WidgetTester tester) async {
    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await tester.tap(find.byType(AppCheckbox));
    await tester.pump();
    await submit(tester);
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isUserLoggedIn'), isTrue);
  });

  testWidgets('without remember me the session is not persisted', (
    WidgetTester tester,
  ) async {
    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await submit(tester);
    await tester.pumpAndSettle();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isUserLoggedIn'), isNull);
  });

  testWidgets('the retry action resubmits the typed credentials', (
    WidgetTester tester,
  ) async {
    dataSource.error = httpFailure(500, serverErrorBody);

    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester, email: 'retry@email.com');
    await submit(tester);
    await tester.pumpAndSettle();

    expect(find.text(en.feedbackServerTitle), findsOneWidget);
    expect(dataSource.callCount, 1);

    await tester.tap(find.text(en.retry));
    await tester.pumpAndSettle();

    expect(dataSource.callCount, 2);
    expect(dataSource.lastBody!.email, 'retry@email.com');
  });

  testWidgets('dismissing the alert removes it', (WidgetTester tester) async {
    dataSource.error = httpFailure(401, badCredentialsBody);

    await pumpSignIn(tester, size: expandedSurface);
    await fillForm(tester);
    await submit(tester);
    await tester.pumpAndSettle();

    expect(find.text(en.feedbackAuthTitle), findsOneWidget);

    await tester.tap(find.byTooltip(en.dismiss));
    await tester.pumpAndSettle();

    expect(find.text(en.feedbackAuthTitle), findsNothing);
  });
}
