part of 'parameters_cubit.dart';

sealed class ParametersState extends Equatable {
  const ParametersState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ParametersInitial extends ParametersState {
  const ParametersInitial();
}

final class ParametersLoading extends ParametersState {
  const ParametersLoading();
}

final class ParametersLoaded extends ParametersState {
  const ParametersLoaded(this.page);

  final ParametersPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class ParametersFailure extends ParametersState {
  const ParametersFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
