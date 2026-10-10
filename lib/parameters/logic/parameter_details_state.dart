part of 'parameter_details_cubit.dart';

sealed class ParameterDetailsState extends Equatable {
  const ParameterDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ParameterDetailsInitial extends ParameterDetailsState {
  const ParameterDetailsInitial();
}

final class ParameterDetailsLoading extends ParameterDetailsState {
  const ParameterDetailsLoading();
}

final class ParameterDetailsLoaded extends ParameterDetailsState {
  const ParameterDetailsLoaded(this.parameter);

  final ParameterModel parameter;

  @override
  List<Object?> get props => <Object?>[parameter];
}

final class ParameterDetailsFailure extends ParameterDetailsState {
  const ParameterDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
