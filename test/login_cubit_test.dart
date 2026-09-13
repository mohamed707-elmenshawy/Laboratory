import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/login/data/repos/login_repo.dart';
import 'package:laboratory/login/logic/login_cubit.dart';
import 'package:laboratory/login/logic/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_login_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeLoginDataSource dataSource;
  late LoginCubit cubit;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    dataSource = FakeLoginDataSource();
    cubit = LoginCubit(LoginRepo(dataSource));
  });

  tearDown(() => cubit.close());

  Future<void> signIn({
    String email = 'admin@email.com',
    String password = 'password',
    bool remember = false,
  }) {
    return cubit.signIn(email: email, password: password, remember: remember);
  }

  group('validation', () {
    test('a blank form reports both fields and sends nothing', () async {
      await signIn(email: '', password: '');

      expect(cubit.state.emailError, isA<ClientFieldError>());
      expect(cubit.state.passwordError, isA<ClientFieldError>());
      expect(
        (cubit.state.emailError! as ClientFieldError).issue,
        LoginFieldIssue.emailRequired,
      );
      expect(cubit.state.isSubmitting, isFalse);
      expect(dataSource.callCount, 0);
    });

    test('a malformed address is rejected before any request', () async {
      await signIn(email: 'not-an-email', password: 'x');

      expect(
        (cubit.state.emailError! as ClientFieldError).issue,
        LoginFieldIssue.emailInvalid,
      );
      expect(dataSource.callCount, 0);
    });

    test('an address over 255 characters is rejected', () async {
      await signIn(email: '${'a' * 250}@example.com', password: 'x');

      expect(
        (cubit.state.emailError! as ClientFieldError).issue,
        LoginFieldIssue.emailTooLong,
      );
      expect(dataSource.callCount, 0);
    });

    test('a short password is accepted', () async {
      await signIn(password: 'a');

      expect(cubit.state.passwordError, isNull);
      expect(dataSource.callCount, 1);
    });

    test('the email is trimmed and the password is not', () async {
      await signIn(email: '  admin@email.com  ', password: '  spaced  ');

      expect(dataSource.lastBody!.email, 'admin@email.com');
      expect(dataSource.lastBody!.password, '  spaced  ');
    });
  });

  group('failures', () {
    test('401 is a form-level credential failure', () async {
      dataSource.error = httpFailure(401, badCredentialsBody);

      await signIn();

      expect(cubit.state.failure, LoginFailureKind.badCredentials);
      expect(cubit.state.emailError, isNull);
      expect(cubit.state.passwordError, isNull);
      expect(
        cubit.state.serverMessage,
        'These credentials do not match our records.',
      );
    });

    test('403 is an unverified account', () async {
      dataSource.error = httpFailure(403, unverifiedBody);

      await signIn();

      expect(cubit.state.failure, LoginFailureKind.accountUnverified);
      expect(cubit.state.serverMessage, contains('not verified'));
    });

    test('422 lands under the fields it names', () async {
      dataSource.error = httpFailure(422, validationBody);

      await signIn();

      expect(cubit.state.failure, isNull);
      expect(
        (cubit.state.emailError! as ServerFieldError).message,
        'The email field is required.',
      );
      expect(
        (cubit.state.passwordError! as ServerFieldError).message,
        'The password field is required.',
      );
    });

    test('429 reads Retry-After when the header is visible', () async {
      dataSource.error = httpFailure(
        429,
        rateLimitedBody,
        headers: <String, List<String>>{
          'retry-after': <String>['42'],
        },
      );

      await signIn();

      expect(cubit.state.failure, LoginFailureKind.rateLimited);
      expect(cubit.state.retryAfterSeconds, 42);
      expect(cubit.state.isRateLimited, isTrue);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('429 falls back to a minute when Retry-After is missing', () async {
      dataSource.error = httpFailure(429, rateLimitedBody);

      await signIn();

      expect(cubit.state.retryAfterSeconds, 60);
    });

    test('5xx is a server failure', () async {
      dataSource.error = httpFailure(500, serverErrorBody);

      await signIn();

      expect(cubit.state.failure, LoginFailureKind.server);
      expect(cubit.state.serverMessage, 'Internal Server Error');
    });

    test('no response is a network failure', () async {
      dataSource.error = networkFailure();

      await signIn();

      expect(cubit.state.failure, LoginFailureKind.network);
      expect(cubit.state.serverMessage, isNull);
    });
  });

  group('success', () {
    test('carries the account through and clears every error', () async {
      dataSource.response = successResponse(name: 'Super Admin');

      await signIn();

      expect(cubit.state.status, LoginStatus.success);
      expect(cubit.state.isBusy, isTrue);
      expect(cubit.state.response!.user.name, 'Super Admin');
      expect(cubit.state.response!.token, isNotEmpty);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.emailError, isNull);
    });

    test('a null tenant_id marks the central super-admin', () async {
      dataSource.response = successResponse();

      await signIn();

      expect(cubit.state.response!.user.isCentralAdmin, isTrue);
    });

    test('a tenant id is carried on the user', () async {
      dataSource.response = successResponse(
        tenantId: '2e6f2cb2-cf84-4161-ad2d-aa79c058082b',
        branchId: 3,
      );

      await signIn();

      expect(
        cubit.state.response!.user.tenantId,
        '2e6f2cb2-cf84-4161-ad2d-aa79c058082b',
      );
      expect(cubit.state.response!.user.isBranchScoped, isTrue);
    });
  });

  group('recovery', () {
    test('typing clears the field error and the form alert', () async {
      dataSource.error = httpFailure(401, badCredentialsBody);
      await signIn();
      expect(cubit.state.failure, isNotNull);

      cubit.onEmailChanged();

      expect(cubit.state.failure, isNull);
      expect(cubit.state.serverMessage, isNull);
    });

    test('typing does not lift an active throttle', () async {
      dataSource.error = httpFailure(429, rateLimitedBody);
      await signIn();

      cubit.onEmailChanged();
      cubit.onPasswordChanged();

      expect(cubit.state.isRateLimited, isTrue);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('a second submit is refused while one is in flight', () async {
      dataSource.response = successResponse();

      final Future<void> first = signIn();
      final Future<void> second = signIn();
      await Future.wait(<Future<void>>[first, second]);

      expect(dataSource.callCount, 1);
    });

    test('changing language retires a server-written message', () async {
      dataSource.error = httpFailure(401, badCredentialsBody);
      await signIn();

      cubit.onLocaleChanged();

      expect(cubit.state.failure, isNull);
    });

    test('changing language keeps a throttle hold', () async {
      dataSource.error = httpFailure(429, rateLimitedBody);
      await signIn();

      cubit.onLocaleChanged();

      expect(cubit.state.isRateLimited, isTrue);
    });
  });
}
