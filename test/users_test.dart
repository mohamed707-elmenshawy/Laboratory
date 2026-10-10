import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratory/branches/data/models/branch_menu_item.dart';
import 'package:laboratory/core/di/dependency_injection.dart';
import 'package:laboratory/core/error/app_error.dart';
import 'package:laboratory/core/error/result.dart';
import 'package:laboratory/core/localization/localization.dart';
import 'package:laboratory/core/phones/phones.dart';
import 'package:laboratory/core/ui/ui.dart';
import 'package:laboratory/laboratories/data/models/laboratory_menu_item.dart';
import 'package:laboratory/laboratories/data/repos/laboratories_repo.dart';
import 'package:laboratory/profile/data/models/profile_model.dart';
import 'package:laboratory/profile/data/models/update_profile_request_body.dart';
import 'package:laboratory/profile/data/repos/profile_repo.dart';
import 'package:laboratory/users/UI/users_view.dart';
import 'package:laboratory/users/data/models/role_model.dart';
import 'package:laboratory/users/data/models/user_model.dart';
import 'package:laboratory/users/data/models/user_request_body.dart';
import 'package:laboratory/users/data/models/users_page.dart';
import 'package:laboratory/users/data/models/users_query.dart';
import 'package:laboratory/users/data/repos/users_repo.dart';
import 'package:laboratory/users/logic/delete_user_cubit.dart';
import 'package:laboratory/users/logic/user_details_cubit.dart';
import 'package:laboratory/users/logic/user_form_cubit.dart';
import 'package:laboratory/users/logic/users_cubit.dart';

import 'support/fake_laboratories_repo.dart';

Map<String, dynamic> _userJson({
  int id = 7,
  String name = 'Sara Ali',
  String email = 'sara@example.com',
  List<String> roles = const <String>['laboratory-admin'],
  bool verified = true,
  Map<String, dynamic>? laboratory = const <String, dynamic>{
    'id': 2,
    'name': 'Heathcote, Walsh and Jones',
  },
  Map<String, dynamic>? branch,
  double? commission,
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'email': email,
  'email_verified_at': verified ? '2026-10-01 10:00:00 AM' : null,
  'tenant_id': 'tenant-1',
  'laboratory': laboratory,
  'branch': branch,
  'commission_percentage': commission,
  'roles': roles,
  'permissions': <String>['users.list', 'users.view'],
  'phones': <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 11,
      'phone': '01012345678',
      'phone_country': 'EG',
      'type': 'phone',
      'type_label': 'Phone',
      'dial_code': '+20',
    },
  ],
};

class FakeUsersRepo implements UsersRepo {
  FakeUsersRepo({this.showError, this.deleteError});

  final AppError? showError;
  final AppError? deleteError;

  final List<UsersQuery> queries = <UsersQuery>[];
  final List<int> shown = <int>[];
  final List<int> deleted = <int>[];
  final List<Map<String, dynamic>> created = <Map<String, dynamic>>[];
  final List<Map<String, dynamic>> saved = <Map<String, dynamic>>[];

  @override
  Future<Result<UsersPage>> fetchUsers(UsersQuery query) async {
    queries.add(query);

    return Success<UsersPage>(
      UsersPage.fromJson(<String, dynamic>{
        'items': <Map<String, dynamic>>[
          _userJson(),
          _userJson(
            id: 9,
            name: 'Omar Fathy',
            email: 'omar@example.com',
            roles: <String>['doctor'],
            verified: false,
            branch: <String, dynamic>{'id': 5, 'name': 'Wolf-Hermann'},
          ),
        ],
        'pagination': <String, dynamic>{
          'meta': <String, dynamic>{
            'total': 2,
            'per_page': query.perPage,
            'current_page': query.page,
            'last_page': 1,
            'from': 1,
            'to': 2,
          },
        },
      }),
    );
  }

  @override
  Future<Result<UserModel>> fetchUser(int id) async {
    shown.add(id);

    if (showError != null) return Failure<UserModel>(showError!);
    return Success<UserModel>(UserModel.fromJson(_userJson(id: id)));
  }

  @override
  Future<Result<void>> createUser(UserRequestBody body) async {
    created.add(body.toJson());
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> updateUser(int id, UserRequestBody body) async {
    saved.add(<String, dynamic>{'id': id, ...body.toJson()});
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> deleteUser(int id) async {
    deleted.add(id);

    if (deleteError != null) return Failure<void>(deleteError!);
    return const Success<void>(null);
  }

  @override
  Future<Result<List<RoleModel>>> fetchRoles() async =>
      const Success<List<RoleModel>>(<RoleModel>[
        RoleModel(name: 'super-admin'),
        RoleModel(name: 'laboratory-admin'),
        RoleModel(name: 'doctor'),
        RoleModel(name: 'team-member'),
      ]);
}

class FakeProfileRepo implements ProfileRepo {
  FakeProfileRepo({this.permissions = _grantable, this.fails = false});

  static const List<String> _grantable = <String>[
    'users.create',
    'users.list',
    'users.view',
    'laboratories.list',
    'laboratories.update',
  ];

  final List<String> permissions;
  final bool fails;

  int profileCalls = 0;

  @override
  Future<Result<ProfileModel>> fetchProfile() async {
    profileCalls++;

    if (fails) {
      return const Failure<ProfileModel>(AppError(kind: AppErrorKind.server));
    }

    return Success<ProfileModel>(
      ProfileModel.fromJson(<String, dynamic>{
        'id': 1,
        'name': 'Super Admin',
        'email': 'admin@email.com',
        'roles': <String>['super-admin'],
        'permissions': permissions,
      }),
    );
  }

  @override
  Future<Result<ProfileModel>> updateProfile(
    UpdateProfileRequestBody body,
  ) async => throw UnimplementedError();

  @override
  Future<Result<List<PhoneTypeOption>>> fetchPhoneTypes() async =>
      const Success<List<PhoneTypeOption>>(<PhoneTypeOption>[
        PhoneTypeOption(value: 'phone', label: 'Phone'),
        PhoneTypeOption(value: 'whatsapp', label: 'Whatsapp'),
        PhoneTypeOption(value: 'both', label: 'Both'),
      ]);
}

class MenuRepo extends FakeLaboratoriesRepoBase {
  @override
  Future<Result<List<BranchMenuItem>>> fetchLaboratoryBranches(
    int laboratoryId,
  ) async => const Success<List<BranchMenuItem>>(<BranchMenuItem>[
    BranchMenuItem(id: 5, name: 'Wolf-Hermann'),
  ]);

  @override
  Future<Result<List<LaboratoryMenuItem>>> fetchLaboratoriesMenu({
    String search = '',
  }) async => const Success<List<LaboratoryMenuItem>>(<LaboratoryMenuItem>[
    LaboratoryMenuItem(id: 2, name: 'Heathcote, Walsh and Jones'),
  ]);
}

Widget _app(UsersCubit cubit) => AppLocaleScope(
  child: MaterialApp(
    home: Scaffold(
      body: BlocProvider<UsersCubit>.value(
        value: cubit,
        child: const UsersView(),
      ),
    ),
  ),
);

Future<void> _open(
  WidgetTester tester,
  FakeUsersRepo repo, {
  FakeProfileRepo? profileRepo,
}) async {
  final FakeProfileRepo profile = profileRepo ?? FakeProfileRepo();
  getIt.registerLazySingleton<LaboratoriesRepo>(MenuRepo.new);
  getIt.registerLazySingleton<UsersRepo>(() => repo);
  getIt.registerFactory<UserDetailsCubit>(() => UserDetailsCubit(repo));
  getIt.registerFactory<DeleteUserCubit>(() => DeleteUserCubit(repo));
  getIt.registerFactory<UserFormCubit>(
    () => UserFormCubit(repo, MenuRepo(), profile),
  );
  addTearDown(() {
    getIt.unregister<LaboratoriesRepo>();
    getIt.unregister<UsersRepo>();
    getIt.unregister<UserDetailsCubit>();
    getIt.unregister<DeleteUserCubit>();
    getIt.unregister<UserFormCubit>();
  });

  tester.view.physicalSize = const Size(1500, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final UsersCubit cubit = UsersCubit(repo)..load();
  addTearDown(cubit.close);

  await tester.pumpWidget(_app(cubit));
  await tester.pumpAndSettle();
}

Future<void> _submit(WidgetTester tester, String label) async {
  final Finder button = find.text(label);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the list asks for page 1 with per_page 10 and renders rows', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    expect(repo.queries.single.toJson(), <String, dynamic>{
      'page': 1,
      'per_page': 10,
    });
    expect(find.text('Sara Ali'), findsOneWidget);
    expect(find.text('sara@example.com'), findsOneWidget);
    expect(find.text('Laboratory admin'), findsOneWidget);
    expect(find.text('Doctor'), findsOneWidget);
    expect(find.text('Showing 1 to 2 of 2 results'), findsOneWidget);
  });

  testWidgets('the laboratory filter reaches the query', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.byType(AppSelect<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heathcote, Walsh and Jones').last);
    await tester.pumpAndSettle();

    expect(repo.queries.last.toJson()['laboratory_id'], 2);
    expect(repo.queries.last.toJson().containsKey('role_ids[]'), isFalse);
  });

  testWidgets('the view action opens the details page for that row', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('View').first);
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[7]);
    expect(find.text('Back to users'), findsOneWidget);
    expect(find.text('+20 01012345678'), findsOneWidget);
  });

  testWidgets('deleting from the list asks first, then refreshes', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    final int before = repo.queries.length;

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Delete Sara Ali?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repo.deleted, <int>[7]);
    expect(find.text('User deleted'), findsOneWidget);
    expect(repo.queries.length, before + 1);
  });

  testWidgets('a central role posts without laboratory, branch or commission', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sara Ali');
    await tester.enterText(find.byType(TextField).at(1), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Super admin'));
    await tester.pumpAndSettle();

    await _submit(tester, 'Create');

    expect(repo.created.single, <String, dynamic>{
      'name': 'Sara Ali',
      'email': 'sara@example.com',
      'password': 'Password123',
      'password_confirmation': 'Password123',
      'roles': <String>['super-admin'],
      'laboratory_id': null,
      'branch_id': null,
      'commission_percentage': null,
      'phones': null,
    });
    expect(find.text('User created'), findsOneWidget);
  });

  testWidgets('a mismatched confirmation blocks the request', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sara Ali');
    await tester.enterText(find.byType(TextField).at(1), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password124');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Super admin'));
    await tester.pumpAndSettle();

    await _submit(tester, 'Create');

    expect(repo.created, isEmpty);
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('a branch role asks for a laboratory and a branch', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Omar Fathy');
    await tester.enterText(find.byType(TextField).at(1), 'omar@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Doctor'));
    await tester.pumpAndSettle();

    expect(find.text('Create'), findsOneWidget);

    await tester.tap(find.byType(AppSelect<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heathcote, Walsh and Jones').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppSelect<int>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wolf-Hermann').last);
    await tester.pumpAndSettle();

    await _submit(tester, 'Create');

    expect(repo.created.single['roles'], <String>['doctor']);
    expect(repo.created.single['laboratory_id'], 2);
    expect(repo.created.single['branch_id'], 5);
  });

  testWidgets('a team member must carry a commission', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Mona Adel');
    await tester.enterText(find.byType(TextField).at(1), 'mona@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Team member'));
    await tester.pumpAndSettle();

    await _submit(tester, 'Create');

    expect(repo.created, isEmpty);
    expect(
      find.text('A commission is required for team members.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).at(4), '20');
    await _submit(tester, 'Create');

    expect(repo.created.single['commission_percentage'], 20);
  });

  testWidgets('choosing a second scope replaces the first role', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppCheckbox, 'Doctor'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppCheckbox, 'Super admin'));
    await tester.pumpAndSettle();

    expect(find.text('Branch'), findsNothing);
  });

  testWidgets('chosen permissions travel in the create payload', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sara Ali');
    await tester.enterText(find.byType(TextField).at(1), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Doctor'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppCheckbox, 'create'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(AppCheckbox, 'view').first);
    await tester.pumpAndSettle();

    expect(find.text('2 selected'), findsOneWidget);

    await tester.tap(find.byType(AppSelect<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heathcote, Walsh and Jones').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppSelect<int>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wolf-Hermann').last);
    await tester.pumpAndSettle();

    await _submit(tester, 'Create');

    expect(
      repo.created.single['permissions'],
      containsAll(<String>['users.create', 'users.view']),
    );
  });

  testWidgets('no permission key is sent when none is picked', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sara Ali');
    await tester.enterText(find.byType(TextField).at(1), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Super admin'));
    await tester.pumpAndSettle();

    await _submit(tester, 'Create');

    expect(repo.created.single.containsKey('permissions'), isFalse);
  });

  testWidgets('a team member never shows the permission picker', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppCheckbox, 'Super admin'));
    await tester.pumpAndSettle();
    expect(find.text('Search permissions'), findsOneWidget);

    await tester.tap(find.widgetWithText(AppCheckbox, 'Team member'));
    await tester.pumpAndSettle();
    expect(find.text('Search permissions'), findsNothing);
  });

  testWidgets('a failed permission load keeps the form usable', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo, profileRepo: FakeProfileRepo(fails: true));

    await tester.tap(find.text('New user'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sara Ali');
    await tester.enterText(find.byType(TextField).at(1), 'sara@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'Password123');
    await tester.enterText(find.byType(TextField).at(3), 'Password123');

    await tester.tap(find.widgetWithText(AppCheckbox, 'Super admin'));
    await tester.pumpAndSettle();

    expect(find.text("Couldn't load the permissions"), findsOneWidget);

    await _submit(tester, 'Create');

    expect(repo.created, hasLength(1));
  });

  testWidgets('editing prefills the row and posts to its id', (
    WidgetTester tester,
  ) async {
    final FakeUsersRepo repo = FakeUsersRepo();
    await _open(tester, repo);

    await tester.tap(find.byTooltip('Edit').first);
    await tester.pumpAndSettle();

    expect(repo.shown, <int>[7]);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'Sara Ali',
    );

    await tester.enterText(find.byType(TextField).first, 'Sara Edited');
    await _submit(tester, 'Save changes');

    expect(repo.saved.single['id'], 7);
    expect(repo.saved.single['name'], 'Sara Edited');
    expect(repo.saved.single.containsKey('password'), isFalse);
    expect(repo.saved.single['roles'], <String>['laboratory-admin']);
    expect(find.text('User saved'), findsOneWidget);
  });
}
