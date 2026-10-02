part of 'delete_branch_cubit.dart';

sealed class DeleteBranchState extends Equatable {
  const DeleteBranchState();

  @override
  List<Object?> get props => <Object?>[];
}

final class DeleteBranchInitial extends DeleteBranchState {
  const DeleteBranchInitial();
}

final class DeleteBranchLoading extends DeleteBranchState {
  const DeleteBranchLoading();
}

final class DeleteBranchSuccess extends DeleteBranchState {
  const DeleteBranchSuccess();
}

final class DeleteBranchFailure extends DeleteBranchState {
  const DeleteBranchFailure(this.error);

  final AppError error;

  @override
  List<Object?> get props => <Object?>[error];
}
