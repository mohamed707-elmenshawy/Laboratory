import 'package:flutter/material.dart';

import 'core/design_system/design_system.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/auth_helper.dart';
import 'core/localization/localization.dart';
import 'core/networking/dio_factory.dart';
import 'home/UI/home_screen.dart';
import 'login/UI/login_screen.dart';
import 'reset_password/UI/reset_password_screen.dart';
import 'reset_password/data/models/reset_password_link.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();
  final bool hasSession = await AuthHelper.restoreSession();

  runApp(
    LaboratoryApp(
      resetPasswordLink: ResetPasswordLink.fromUri(Uri.base),
      hasSession: hasSession,
    ),
  );
}

class LaboratoryApp extends StatelessWidget {
  const LaboratoryApp({
    super.key,
    this.resetPasswordLink,
    this.hasSession = false,
  });

  final ResetPasswordLink? resetPasswordLink;
  final bool hasSession;

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      onLocaleChanged: (AppLocale locale) => DioFactory.setLocale(locale.code),
      child: Builder(
        builder: (BuildContext context) {
          final AppLocale locale = context.appLocale;

          return MaterialApp(
            title: 'Laboratory Management System',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(arabic: locale.isRtl),
            builder: (BuildContext context, Widget? child) => Directionality(
              textDirection: locale.textDirection,
              child: child!,
            ),
            onGenerateRoute: (_) => LoginScreen.route(),
            onGenerateInitialRoutes: (_) => <Route<dynamic>>[
              if (resetPasswordLink
                  case final ResetPasswordLink link) ...<Route<dynamic>>[
                LoginScreen.route(),
                ResetPasswordScreen.route(link: link),
              ] else if (hasSession)
                HomeScreen.route()
              else
                LoginScreen.route(),
            ],
          );
        },
      ),
    );
  }
}
