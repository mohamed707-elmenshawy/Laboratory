import '../error/app_error.dart';
import '../localization/app_strings.dart';
import 'app_feedback.dart';

extension AppErrorFeedback on AppError {
  /// The alert for this error, in the current language.
  ///
  /// [title] says what failed on the calling screen (e.g. "Sign-in failed")
  /// and is used when the server explained why.
  AppFeedback toFeedback(AppStrings s, {required String title}) =>
      switch (kind) {
        AppErrorKind.network || AppErrorKind.timeout => AppFeedback.danger(
          title: s.feedbackNetworkTitle,
          message: s.networkMessage,
        ),
        // The server's text for these ("Internal Server Error") is not
        // written for users, so it is never shown.
        AppErrorKind.server ||
        AppErrorKind.cancelled ||
        AppErrorKind.parsing ||
        AppErrorKind.unknown => AppFeedback.danger(
          title: s.feedbackServerTitle,
          message: s.serverErrorMessage,
        ),
        AppErrorKind.badRequest ||
        AppErrorKind.unauthorized ||
        AppErrorKind.forbidden ||
        AppErrorKind.notFound ||
        AppErrorKind.validation ||
        AppErrorKind.rateLimited => AppFeedback.danger(
          title: title,
          message: message ?? s.serverErrorMessage,
        ),
      };
}
