part of 'update_branch_cubit.dart';

sealed class UpdateBranchState extends Equatable {
  const UpdateBranchState();

  @override
  List<Object?> get props => <Object?>[];
}

final class UpdateBranchInitial extends UpdateBranchState {
  const UpdateBranchInitial();
}

final class UpdateBranchEditing extends UpdateBranchState {
  const UpdateBranchEditing(this.revision);

  final int revision;

  @override
  List<Object?> get props => <Object?>[revision];
}

final class UpdateBranchLoading extends UpdateBranchState {
  const UpdateBranchLoading();
}

final class UpdateBranchSuccess extends UpdateBranchState {
  const UpdateBranchSuccess(this.branch);

  final BranchModel branch;

  @override
  List<Object?> get props => <Object?>[branch];
}

final class UpdateBranchCreated extends UpdateBranchState {
  const UpdateBranchCreated();
}

final class UpdateBranchFailure extends UpdateBranchState {
  const UpdateBranchFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
