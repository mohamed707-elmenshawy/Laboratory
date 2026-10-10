part of 'parameter_status_cubit.dart';

sealed class ParameterStatusState extends Equatable {
  const ParameterStatusState();

  @override
  List<Object?> get props => <Object?>[];
}

final class ParameterStatusInitial extends ParameterStatusState {
  const ParameterStatusInitial();
}

final class ParameterStatusLoading extends ParameterStatusState {
  const ParameterStatusLoading(this.id);

  final int id;

  @override
  List<Object?> get props => <Object?>[id];
}

final class ParameterStatusSuccess extends ParameterStatusState {
  const ParameterStatusSuccess(this.parameter);

  final ParameterModel parameter;

  @override
  List<Object?> get props => <Object?>[parameter];
}

final class ParameterStatusFailure extends ParameterStatusState {
  const ParameterStatusFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
