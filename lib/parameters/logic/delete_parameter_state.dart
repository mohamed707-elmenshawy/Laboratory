part of 'delete_parameter_cubit.dart';

sealed class DeleteParameterState extends Equatable {
  const DeleteParameterState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteParameterInitial extends DeleteParameterState {
  const DeleteParameterInitial();
}

final class DeleteParameterLoading extends DeleteParameterState {
  const DeleteParameterLoading();
}

final class DeleteParameterSuccess extends DeleteParameterState {
  const DeleteParameterSuccess();
}

final class DeleteParameterFailure extends DeleteParameterState {
  const DeleteParameterFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
