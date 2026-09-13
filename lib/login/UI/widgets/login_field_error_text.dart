import '../../../core/localization/localization.dart';
import '../../logic/login_state.dart';

extension LoginFieldErrorText on LoginFieldError {
  String localized(AppStrings s) => switch (this) {
    ServerFieldError(:final String message) => message,
    ClientFieldError(:final LoginFieldIssue issue) => switch (issue) {
      LoginFieldIssue.emailRequired => s.emailRequired,
      LoginFieldIssue.emailInvalid => s.emailInvalid,
      LoginFieldIssue.emailTooLong => s.emailTooLong,
      LoginFieldIssue.passwordRequired => s.passwordRequired,
    },
  };
}
