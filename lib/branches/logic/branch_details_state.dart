part of 'branch_details_cubit.dart';

sealed class BranchDetailsState extends Equatable {
  const BranchDetailsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class BranchDetailsInitial extends BranchDetailsState {
  const BranchDetailsInitial();
}

final class BranchDetailsLoading extends BranchDetailsState {
  const BranchDetailsLoading();
}

final class BranchDetailsLoaded extends BranchDetailsState {
  const BranchDetailsLoaded(this.branch);

  final BranchModel branch;

  @override
  List<Object?> get props => <Object?>[branch];
}

final class BranchDetailsFailure extends BranchDetailsState {
  const BranchDetailsFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
