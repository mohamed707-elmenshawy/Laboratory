import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../../core/helpers/auth_helper.dart';
import '../../core/models/user_model.dart';
import '../data/repos/home_repo.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepo) : super(const HomeInitial());

  final HomeRepo _homeRepo;

  UserModel? get user => switch (state) {
    HomeLoaded(:final UserModel user) => user,
    _ => null,
  };

  Future<void> loadProfile() async {
    if (state is HomeLoading) return;

    emit(const HomeLoading());

    final Result<UserModel> result = await _homeRepo.fetchProfile();

    if (isClosed) return;

    switch (result) {
      case Success<UserModel>(:final UserModel data):
        emit(HomeLoaded(data));
      case Failure<UserModel>(:final AppError error)
          when error.kind == AppErrorKind.unauthorized:
        await AuthHelper.closeSession();
        if (isClosed) return;
        emit(const HomeSessionExpired());
      case Failure<UserModel>(:final AppError error):
        emit(HomeFailure(error));
    }
  }
}
