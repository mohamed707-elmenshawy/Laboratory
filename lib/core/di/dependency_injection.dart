import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../forgot_password/data/repos/forgot_password_repo.dart';
import '../../forgot_password/logic/forgot_password_cubit.dart';
import '../../login/data/repos/login_repo.dart';
import '../../login/logic/login_cubit.dart';
import '../../register/data/repos/register_repo.dart';
import '../../register/logic/register_cubit.dart';
import '../../reset_password/data/repos/reset_password_repo.dart';
import '../../reset_password/logic/reset_password_cubit.dart';
import '../../verification/data/repos/verification_repo.dart';
import '../../verification/logic/verification_cubit.dart';
import '../networking/dio_factory.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerSingleton<Dio>(DioFactory.getDio());

  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt<Dio>()));

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));

  getIt.registerLazySingleton<RegisterRepo>(() => RegisterRepo(getIt<Dio>()));

  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<RegisterRepo>()),
  );

  getIt.registerLazySingleton<VerificationRepo>(
    () => VerificationRepo(getIt<Dio>()),
  );

  getIt.registerFactory<VerificationCubit>(
    () => VerificationCubit(getIt<VerificationRepo>()),
  );

  getIt.registerLazySingleton<ForgotPasswordRepo>(
    () => ForgotPasswordRepo(getIt<Dio>()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(getIt<ForgotPasswordRepo>()),
  );

  getIt.registerLazySingleton<ResetPasswordRepo>(
    () => ResetPasswordRepo(getIt<Dio>()),
  );

  getIt.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(getIt<ResetPasswordRepo>()),
  );
}
