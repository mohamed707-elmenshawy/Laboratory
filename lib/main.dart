import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/design_system/design_system.dart';
import 'core/helpers/auth_helper.dart';
import 'core/localization/localization.dart';
import 'core/networking/dio_factory.dart';
import 'login/UI/login_screen.dart';
import 'login/data/datasources/login_remote_data_source.dart';
import 'login/data/repos/login_repo.dart';
import 'login/logic/login_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final LoginRepo loginRepo = LoginRepo(
    LoginRemoteDataSourceImpl(DioFactory.getDio()),
  );

  await AuthHelper.restoreSession();

  runApp(LaboratoryApp(loginRepo: loginRepo));
}

class LaboratoryApp extends StatelessWidget {
  const LaboratoryApp({super.key, required this.loginRepo});

  final LoginRepo loginRepo;

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
              create: (_) => LoginCubit(loginRepo),
              child: const LoginScreen(),
            ),
          );
        },
      ),
    );
  }
}
