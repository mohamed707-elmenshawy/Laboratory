import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design_system/design_system.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/auth_helper.dart';
import 'core/localization/localization.dart';
import 'core/networking/dio_factory.dart';
import 'login/UI/login_screen.dart';
import 'login/logic/login_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupGetIt();
  await AuthHelper.restoreSession();

  runApp(const LaboratoryApp());
}

class LaboratoryApp extends StatelessWidget {
  const LaboratoryApp({super.key});

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
            home: BlocProvider<LoginCubit>(
              create: (_) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
