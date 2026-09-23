import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/design_system/design_system.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/auth_helper.dart';
import 'core/helpers/locale_helper.dart';
import 'core/localization/localization.dart';
import 'core/networking/dio_factory.dart';
import 'home/UI/home_screen.dart';
import 'login/UI/login_screen.dart';
import 'reset_password/UI/reset_password_screen.dart';
import 'reset_password/data/models/reset_password_link.dart';
import 'settings/logic/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();
  getIt<SettingsCubit>();
  final AppLocale? savedLocale = await LocaleHelper.restore();
  final AppLocale initialLocale = savedLocale ?? AppLocale.en;
  DioFactory.setLocale(initialLocale.code);
  final bool hasSession = await AuthHelper.restoreSession();

  runApp(
    LaboratoryApp(
      resetPasswordLink: ResetPasswordLink.fromUri(Uri.base),
      hasSession: hasSession,
      initialLocale: initialLocale,
      hasSavedLocale: savedLocale != null,
    ),
  );
}

class LaboratoryApp extends StatelessWidget {
  const LaboratoryApp({
    super.key,
    this.resetPasswordLink,
    this.hasSession = false,
    this.initialLocale = AppLocale.en,
    this.hasSavedLocale = false,
  });

  final ResetPasswordLink? resetPasswordLink;
  final bool hasSession;
  final AppLocale initialLocale;
  final bool hasSavedLocale;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>.value(
      value: getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          final LabSettings settings = switch (state) {
            SettingsLoaded(:final LabSettings settings) => settings,
            _ => LabSettings.fallback,
          };

          return AppLocaleScope(
            initialLocale: initialLocale,
            settings: settings,
            hasSavedLocale: hasSavedLocale,
            onLocaleChanged: (AppLocale locale) {
              DioFactory.setLocale(locale.code);
              LocaleHelper.persist(locale);
            },
            child: Builder(
              builder: (BuildContext context) {
                final AppLocale locale = context.appLocale;
                final String title = context.labSettings.nameFor(
                  locale.code,
                  fallback: 'Laboratory Management System',
                );

                return MaterialApp(
                  title: title,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light(arabic: locale.isRtl),
                  builder: (BuildContext context, Widget? child) =>
                      Directionality(
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
        },
      ),
    );
  }
}
