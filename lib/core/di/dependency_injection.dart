import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../change_password/data/repos/change_password_repo.dart';
import '../../change_password/logic/change_password_cubit.dart';
import '../../forgot_password/data/repos/forgot_password_repo.dart';
import '../../forgot_password/logic/forgot_password_cubit.dart';
import '../../home/data/repos/home_repo.dart';
import '../../branches/data/repos/branches_repo.dart';
import '../../branches/logic/branch_details_cubit.dart';
import '../../branches/logic/branches_cubit.dart';
import '../../branches/logic/branch_status_cubit.dart';
import '../../branches/logic/delete_branch_cubit.dart';
import '../../branches/logic/update_branch_cubit.dart';
import '../../laboratories/data/repos/laboratories_repo.dart';
import '../../sample_types/data/repos/sample_types_repo.dart';
import '../../sample_types/logic/delete_sample_type_cubit.dart';
import '../../sample_types/logic/sample_type_details_cubit.dart';
import '../../sample_types/logic/sample_type_form_cubit.dart';
import '../../sample_types/logic/sample_type_status_cubit.dart';
import '../../sample_types/logic/sample_types_cubit.dart';
import '../../test_categories/data/repos/test_categories_repo.dart';
import '../../units/data/repos/units_repo.dart';
import '../../units/logic/delete_unit_cubit.dart';
import '../../units/logic/unit_details_cubit.dart';
import '../../units/logic/unit_form_cubit.dart';
import '../../units/logic/unit_status_cubit.dart';
import '../../units/logic/units_cubit.dart';
import '../../test_categories/logic/delete_test_category_cubit.dart';
import '../../test_categories/logic/test_categories_cubit.dart';
import '../../test_categories/logic/test_category_details_cubit.dart';
import '../../test_categories/logic/test_category_form_cubit.dart';
import '../../test_categories/logic/test_category_status_cubit.dart';
import '../../laboratories/logic/create_laboratory_cubit.dart';
import '../../laboratories/logic/delete_laboratory_cubit.dart';
import '../../laboratories/logic/update_laboratory_cubit.dart';
import '../../laboratories/logic/laboratory_details_cubit.dart';
import '../../laboratories/logic/laboratory_status_cubit.dart';
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
import '../../terms/data/repos/terms_repo.dart';
import '../../terms/logic/terms_cubit.dart';
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

  getIt.registerFactory<CreateLaboratoryCubit>(
    () => CreateLaboratoryCubit(getIt<LaboratoriesRepo>()),
  );

  getIt.registerFactory<UpdateLaboratoryCubit>(
    () => UpdateLaboratoryCubit(getIt<LaboratoriesRepo>()),
  );

  getIt.registerFactory<DeleteLaboratoryCubit>(
    () => DeleteLaboratoryCubit(getIt<LaboratoriesRepo>()),
  );

  getIt.registerFactory<LaboratoryDetailsCubit>(
    () => LaboratoryDetailsCubit(getIt<LaboratoriesRepo>()),
  );

  getIt.registerFactory<LaboratoryStatusCubit>(
    () => LaboratoryStatusCubit(getIt<LaboratoriesRepo>()),
  );

  getIt.registerLazySingleton<BranchesRepo>(() => BranchesRepo(getIt<Dio>()));

  getIt.registerFactory<BranchesCubit>(
    () => BranchesCubit(getIt<BranchesRepo>()),
  );

  getIt.registerFactory<BranchDetailsCubit>(
    () => BranchDetailsCubit(getIt<BranchesRepo>()),
  );

  getIt.registerFactory<UpdateBranchCubit>(
    () => UpdateBranchCubit(getIt<BranchesRepo>(), getIt<LaboratoriesRepo>()),
  );

  getIt.registerFactory<DeleteBranchCubit>(
    () => DeleteBranchCubit(getIt<BranchesRepo>()),
  );

  getIt.registerFactory<BranchStatusCubit>(
    () => BranchStatusCubit(getIt<BranchesRepo>()),
  );

  getIt.registerLazySingleton<TestCategoriesRepo>(
    () => TestCategoriesRepo(getIt<Dio>()),
  );

  getIt.registerFactory<TestCategoriesCubit>(
    () => TestCategoriesCubit(getIt<TestCategoriesRepo>()),
  );

  getIt.registerFactory<TestCategoryDetailsCubit>(
    () => TestCategoryDetailsCubit(getIt<TestCategoriesRepo>()),
  );

  getIt.registerFactory<DeleteTestCategoryCubit>(
    () => DeleteTestCategoryCubit(getIt<TestCategoriesRepo>()),
  );

  getIt.registerFactory<TestCategoryStatusCubit>(
    () => TestCategoryStatusCubit(getIt<TestCategoriesRepo>()),
  );

  getIt.registerLazySingleton<SampleTypesRepo>(
    () => SampleTypesRepo(getIt<Dio>()),
  );

  getIt.registerFactory<SampleTypesCubit>(
    () => SampleTypesCubit(getIt<SampleTypesRepo>()),
  );

  getIt.registerFactory<SampleTypeDetailsCubit>(
    () => SampleTypeDetailsCubit(getIt<SampleTypesRepo>()),
  );

  getIt.registerFactory<DeleteSampleTypeCubit>(
    () => DeleteSampleTypeCubit(getIt<SampleTypesRepo>()),
  );

  getIt.registerFactory<SampleTypeStatusCubit>(
    () => SampleTypeStatusCubit(getIt<SampleTypesRepo>()),
  );

  getIt.registerFactory<SampleTypeFormCubit>(
    () => SampleTypeFormCubit(
      getIt<SampleTypesRepo>(),
      getIt<LaboratoriesRepo>(),
      getIt<BranchesRepo>(),
    ),
  );

  getIt.registerLazySingleton<UnitsRepo>(() => UnitsRepo(getIt<Dio>()));

  getIt.registerFactory<UnitsCubit>(() => UnitsCubit(getIt<UnitsRepo>()));

  getIt.registerFactory<UnitDetailsCubit>(
    () => UnitDetailsCubit(getIt<UnitsRepo>()),
  );

  getIt.registerFactory<DeleteUnitCubit>(
    () => DeleteUnitCubit(getIt<UnitsRepo>()),
  );

  getIt.registerFactory<UnitStatusCubit>(
    () => UnitStatusCubit(getIt<UnitsRepo>()),
  );

  getIt.registerFactory<UnitFormCubit>(
    () => UnitFormCubit(
      getIt<UnitsRepo>(),
      getIt<LaboratoriesRepo>(),
      getIt<BranchesRepo>(),
    ),
  );

  getIt.registerFactory<TestCategoryFormCubit>(
    () => TestCategoryFormCubit(
      getIt<TestCategoriesRepo>(),
      getIt<LaboratoriesRepo>(),
      getIt<BranchesRepo>(),
    ),
  );

  getIt.registerLazySingleton<SettingsRepo>(() => SettingsRepo(getIt<Dio>()));

  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepo>()),
  );

  getIt.registerLazySingleton<TermsRepo>(() => TermsRepo(getIt<Dio>()));

  getIt.registerFactory<TermsCubit>(() => TermsCubit(getIt<TermsRepo>()));
}
