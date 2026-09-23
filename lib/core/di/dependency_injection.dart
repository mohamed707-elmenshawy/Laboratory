import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../change_password/data/repos/change_password_repo.dart';
import '../../change_password/logic/change_password_cubit.dart';
import '../../forgot_password/data/repos/forgot_password_repo.dart';
import '../../forgot_password/logic/forgot_password_cubit.dart';
import '../../home/data/repos/home_repo.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../../laboratories/logic/laboratories_cubit.dart';
import '../../home/logic/home_cubit.dart';
import '../../home/logic/logout_cubit.dart';
import '../../login/data/repos/login_repo.dart';
import '../../login/logic/login_cubit.dart';
import '../../profile/data/repos/profile_repo.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../profile/logic/update_profile_cubit.dart';
import '../../register/data/repos/register_repo.dart';
import '../../register/logic/register_cubit.dart';
import '../../reset_password/data/repos/reset_password_repo.dart';
import '../../reset_password/logic/reset_password_cubit.dart';
import '../../settings/data/repos/settings_repo.dart';
import '../../settings/logic/settings_cubit.dart';
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

  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt<Dio>()));

  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));

  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt<HomeRepo>()));

  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt<Dio>()));

  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt<ProfileRepo>()));

  getIt.registerFactory<UpdateProfileCubit>(
    () => UpdateProfileCubit(getIt<ProfileRepo>()),
  );

  getIt.registerLazySingleton<ChangePasswordRepo>(
    () => ChangePasswordRepo(getIt<Dio>()),
  );

  getIt.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(getIt<ChangePasswordRepo>()),
  );

  getIt.registerLazySingleton<LaboratoriesRepo>(
    () => LaboratoriesRepo(getIt<Dio>()),
  );

  getIt.registerFactory<LaboratoriesCubit>(
    () => LaboratoriesCubit(getIt<LaboratoriesRepo>()),
  );

  getIt.registerLazySingleton<SettingsRepo>(() => SettingsRepo(getIt<Dio>()));

  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepo>()),
  );
}
