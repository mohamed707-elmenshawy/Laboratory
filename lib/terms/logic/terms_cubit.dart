import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/app_error.dart';
import '../../core/error/result.dart';
import '../data/models/term_model.dart';
import '../data/repos/terms_repo.dart';
part 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit(this._termsRepo) : super(const TermsInitial());

  final TermsRepo _termsRepo;

  Future<void> load() async {
    if (state is TermsLoading) return;

    emit(const TermsLoading());

    final Result<List<TermModel>> result = await _termsRepo.fetchTerms();

    if (isClosed) return;

    switch (result) {
      case Success<List<TermModel>>(:final List<TermModel> data):
        emit(TermsLoaded(data));
      case Failure<List<TermModel>>(:final AppError error):
        emit(TermsFailure(error));
    }
  }
}
