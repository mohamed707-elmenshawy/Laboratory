import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/branches/data/models/branch_model.dart';
import 'package:laboratory/branches/data/models/branches_page.dart';
import 'package:laboratory/branches/data/models/branches_query.dart';
import 'package:laboratory/branches/data/models/update_branch_request_body.dart';
import 'package:laboratory/branches/data/repos/branches_repo.dart';
import 'package:laboratory/branches/logic/branch_details_cubit.dart';
import 'package:laboratory/branches/logic/branches_cubit.dart';
import 'package:laboratory/branches/logic/delete_branch_cubit.dart';
import 'package:laboratory/branches/logic/update_branch_cubit.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/core/models/user_model.dart';
import 'package:laboratory/home/UI/home_screen.dart';
import 'package:laboratory/home/UI/widgets/home_nav_item.dart';
import 'package:laboratory/home/data/repos/home_repo.dart';
import 'package:laboratory/home/logic/home_cubit.dart';
import 'package:laboratory/home/logic/logout_cubit.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';
import 'package:laboratory/laboratories/logic/laboratories_cubit.dart';
import 'package:laboratory/laboratories/logic/laboratory_status_cubit.dart';

import 'support/fake_laboratories_repo.dart';

class _HomeRepo extends HomeRepo {
  _HomeRepo() : super(Dio());

  @override
  Future<Result<UserModel>> fetchProfile() async => const Success<UserModel>(
    UserModel(
      id: 1,
      name: 'Admin',
      email: 'admin@laboratory.com',
      tenantId: '1',
      branchId: null,
    ),
  );

  @override
  Future<Result<void>> logout() async => const Success<void>(null);
}

class _BranchesRepo implements BranchesRepo {
  Map<String, dynamic> get _branch => <String, dynamic>{
    'id': 13,
    'name': 'Cairo branch',
    'address': 'test address',
    'is_active': true,
    'is_main_branch': true,
    'phones': <Map<String, dynamic>>[],
    'laboratory': <String, dynamic>{'id': 1, 'name': 'Lubowitz Lab'},
  };

  @override
  Future<Result<BranchesPage>> fetchBranches(BranchesQuery query) async =>
      Success<BranchesPage>(
        BranchesPage.fromJson(<String, dynamic>{
          'items': <Map<String, dynamic>>[_branch],
          'pagination': <String, dynamic>{
            'meta': <String, dynamic>{
              'total': 1,
              'per_page': query.perPage,
              'current_page': 1,
              'last_page': 1,
              'from': 1,
              'to': 1,
            },
          },
        }),
      );

  @override
  Future<Result<BranchModel>> fetchBranch(int id) async =>
      Success<BranchModel>(BranchModel.fromJson(_branch));

  @override
  Future<Result<void>> createBranch(UpdateBranchRequestBody body) async =>
      const Success<void>(null);

  @override
  Future<Result<BranchModel>> updateBranch(
    int id,
    UpdateBranchRequestBody body,
  ) async => Success<BranchModel>(BranchModel.fromJson(_branch));

  @override
  Future<Result<void>> deleteBranch(int id) async => const Success<void>(null);
}

void main() {
  setUp(() {
    final FakeLaboratoriesRepoBase laboratories = FakeLaboratoriesRepoBase();
    final _BranchesRepo branches = _BranchesRepo();

    getIt.registerLazySingleton<LaboratoriesRepo>(() => laboratories);
    getIt.registerLazySingleton<BranchesRepo>(() => branches);
    getIt.registerFactory<LaboratoriesCubit>(
      () => LaboratoriesCubit(getIt<LaboratoriesRepo>()),
    );
    getIt.registerFactory<LaboratoryStatusCubit>(
      () => LaboratoryStatusCubit(getIt<LaboratoriesRepo>()),
    );
    getIt.registerFactory<BranchesCubit>(
      () => BranchesCubit(getIt<BranchesRepo>()),
    );
    getIt.registerFactory<BranchDetailsCubit>(
      () => BranchDetailsCubit(getIt<BranchesRepo>()),
    );
    getIt.registerFactory<DeleteBranchCubit>(
      () => DeleteBranchCubit(getIt<BranchesRepo>()),
    );
    getIt.registerFactory<UpdateBranchCubit>(
      () => UpdateBranchCubit(getIt<BranchesRepo>(), getIt<LaboratoriesRepo>()),
    );
  });

  tearDown(getIt.reset);

  testWidgets(
    'Branches in the home nav opens the branch list from another page and from a branch',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1400, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final _HomeRepo home = _HomeRepo();

      await tester.pumpWidget(
        AppLocaleScope(
          child: MaterialApp(
            home: MultiBlocProvider(
              providers: <BlocProvider<dynamic>>[
                BlocProvider<HomeCubit>(create: (_) => HomeCubit(home)),
                BlocProvider<LogoutCubit>(create: (_) => LogoutCubit(home)),
              ],
              child: const HomeScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Laboratories'), findsWidgets);
      expect(find.text('New branch'), findsNothing);

      await tester.tap(find.widgetWithText(HomeNavItem, 'Branches'));
      await tester.pumpAndSettle();

      expect(find.text('Cairo branch'), findsOneWidget);
      expect(find.text('New branch'), findsOneWidget);

      await tester.tap(find.byTooltip('View'));
      await tester.pumpAndSettle();

      expect(find.text('Back to branches'), findsOneWidget);

      await tester.tap(find.widgetWithText(HomeNavItem, 'Branches'));
      await tester.pumpAndSettle();

      expect(find.text('Back to branches'), findsNothing);
      expect(find.text('Cairo branch'), findsOneWidget);
      expect(find.text('New branch'), findsOneWidget);
    },
  );
}
