import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/helpers/auth_helper.dart';
import '../data/repos/home_repo.dart';
part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit(this._homeRepo) : super(const LogoutInitial());

  final HomeRepo _homeRepo;

  bool get isBusy => state is LogoutLoading || state is LogoutSuccess;

  Future<void> logout() async {
    if (isBusy) return;

    emit(const LogoutLoading());

    await _homeRepo.logout();
    await AuthHelper.closeSession();

    if (isClosed) return;
    emit(const LogoutSuccess());
  }
}
