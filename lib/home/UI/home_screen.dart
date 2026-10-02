import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/dependency_injection.dart';
import '../../core/localization/localization.dart';
import '../../core/networking/dio_factory.dart';
import '../../change_password/UI/change_password_view.dart';
import '../../branches/UI/branches_view.dart';
import '../../laboratories/UI/laboratories_view.dart';
import '../../login/UI/login_screen.dart';
import '../../profile/UI/profile_view.dart';
import '../logic/home_cubit.dart';
import '../logic/logout_cubit.dart';
import 'widgets/home_content.dart';
import 'widgets/home_destination.dart';
import 'widgets/home_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<HomeCubit>(
          create: (_) => getIt<HomeCubit>()..loadProfile(),
        ),
        BlocProvider<LogoutCubit>(create: (_) => getIt<LogoutCubit>()),
      ],
      child: const HomeScreen(),
    ),
  );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppLocale? _locale;
  HomeDestination _destination = HomeDestination.overview;
  int _branchesEntry = 0;

  void _select(HomeDestination destination) {
    setState(() {
      _destination = destination;
      if (destination == HomeDestination.branches) _branchesEntry++;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final AppLocale locale = context.appLocale;
    if (locale == _locale) return;

    _locale = locale;
    DioFactory.setLocale(locale.code);
  }

  void _toLogin() => Navigator.of(
    context,
  ).pushAndRemoveUntil(LoginScreen.route(), (Route<dynamic> _) => false);

  @override
  Widget build(BuildContext context) {
    final AppStrings s = context.strings;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (HomeState previous, HomeState current) =>
              current is HomeSessionExpired,
          listener: (BuildContext context, HomeState state) => _toLogin(),
        ),
        BlocListener<LogoutCubit, LogoutState>(
          listenWhen: (LogoutState previous, LogoutState current) =>
              current is LogoutSuccess,
          listener: (BuildContext context, LogoutState state) => _toLogin(),
        ),
      ],
      child: HomeLayout(
        selected: _destination,
        onSelected: _select,
        title: _destination.label(s),
        body: KeyedSubtree(
          key: ValueKey<Object>(
            _destination == HomeDestination.branches
                ? 'branches-$_branchesEntry'
                : _destination,
          ),
          child: switch (_destination) {
            HomeDestination.profile => ProfileView.page(),
            HomeDestination.changePassword => ChangePasswordView.page(
              email: context.read<HomeCubit>().user?.email ?? '',
            ),
            HomeDestination.overview => LaboratoriesView.page(),
            HomeDestination.branches => BranchesView.page(),
            HomeDestination.analytics => const HomeContent(),
          },
        ),
      ),
    );
  }
}
