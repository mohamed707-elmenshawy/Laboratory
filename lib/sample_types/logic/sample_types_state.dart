part of 'sample_types_cubit.dart';

sealed class SampleTypesState extends Equatable {
  const SampleTypesState();

  @override
  List<Object?> get props => <Object?>[];
}

final class SampleTypesInitial extends SampleTypesState {
  const SampleTypesInitial();
}

final class SampleTypesLoading extends SampleTypesState {
  const SampleTypesLoading();
}

final class SampleTypesLoaded extends SampleTypesState {
  const SampleTypesLoaded(this.page);

  final SampleTypesPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class SampleTypesFailure extends SampleTypesState {
  const SampleTypesFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
