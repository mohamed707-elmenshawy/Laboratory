part of 'terms_cubit.dart';

sealed class TermsState extends Equatable {
  const TermsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class TermsInitial extends TermsState {
  const TermsInitial();
}

final class TermsLoading extends TermsState {
  const TermsLoading();
}

final class TermsLoaded extends TermsState {
  const TermsLoaded(this.terms);

  final List<TermModel> terms;

  @override
  List<Object?> get props => <Object?>[terms];
}

final class TermsFailure extends TermsState {
  const TermsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
