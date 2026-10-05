part of 'sample_type_details_cubit.dart';

sealed class SampleTypeDetailsState extends Equatable {
  const SampleTypeDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SampleTypeDetailsInitial extends SampleTypeDetailsState {
  const SampleTypeDetailsInitial();
}

final class SampleTypeDetailsLoading extends SampleTypeDetailsState {
  const SampleTypeDetailsLoading();
}

final class SampleTypeDetailsLoaded extends SampleTypeDetailsState {
  const SampleTypeDetailsLoaded(this.sampleType);

  final SampleTypeModel sampleType;

  @override
  List<Object?> get props => <Object?>[sampleType];
}

final class SampleTypeDetailsFailure extends SampleTypeDetailsState {
  const SampleTypeDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
