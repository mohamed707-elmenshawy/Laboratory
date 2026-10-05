part of 'delete_sample_type_cubit.dart';

sealed class DeleteSampleTypeState extends Equatable {
  const DeleteSampleTypeState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteSampleTypeInitial extends DeleteSampleTypeState {
  const DeleteSampleTypeInitial();
}

final class DeleteSampleTypeLoading extends DeleteSampleTypeState {
  const DeleteSampleTypeLoading();
}

final class DeleteSampleTypeSuccess extends DeleteSampleTypeState {
  const DeleteSampleTypeSuccess();
}

final class DeleteSampleTypeFailure extends DeleteSampleTypeState {
  const DeleteSampleTypeFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
