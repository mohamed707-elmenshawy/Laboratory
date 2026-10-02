part of 'branches_cubit.dart';

sealed class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object?> get props => <Object?>[];
}

final class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

final class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

final class BranchesLoaded extends BranchesState {
  const BranchesLoaded(this.page);

  final BranchesPage page;

  @override
  List<Object?> get props => <Object?>[page];
}

final class BranchesFailure extends BranchesState {
  const BranchesFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
