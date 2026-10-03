part of 'branch_status_cubit.dart';

sealed class BranchStatusState extends Equatable {
  const BranchStatusState();

  @override
  List<Object?> get props => <Object?>[];
}

final class BranchStatusInitial extends BranchStatusState {
  const BranchStatusInitial();
}

final class BranchStatusLoading extends BranchStatusState {
  const BranchStatusLoading(this.id);

  final int id;

  @override
  List<Object?> get props => <Object?>[id];
}

final class BranchStatusSuccess extends BranchStatusState {
  const BranchStatusSuccess(this.branch);

  final BranchModel branch;

  @override
  List<Object?> get props => <Object?>[branch];
}

final class BranchStatusFailure extends BranchStatusState {
  const BranchStatusFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
