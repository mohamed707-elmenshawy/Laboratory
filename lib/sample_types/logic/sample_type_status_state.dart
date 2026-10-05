part of 'sample_type_status_cubit.dart';

sealed class SampleTypeStatusState extends Equatable {
  const SampleTypeStatusState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SampleTypeStatusInitial extends SampleTypeStatusState {
  const SampleTypeStatusInitial();
}

final class SampleTypeStatusLoading extends SampleTypeStatusState {
  const SampleTypeStatusLoading(this.id);

  final int id;

  @override
  List<Object?> get props => <Object?>[id];
}

final class SampleTypeStatusSuccess extends SampleTypeStatusState {
  const SampleTypeStatusSuccess(this.sampleType);

  final SampleTypeModel sampleType;

  @override
  List<Object?> get props => <Object?>[sampleType];
}

final class SampleTypeStatusFailure extends SampleTypeStatusState {
  const SampleTypeStatusFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
