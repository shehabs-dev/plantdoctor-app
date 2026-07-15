part of 'patch_cubit.dart';

sealed class PatchState extends Equatable {}

class PatchInitial extends PatchState {
  @override
  List<Object?> get props => [];
}

class PatchChecking extends PatchState {
  @override
  List<Object?> get props => [];
}

class PatchUpToDate extends PatchState {
  @override
  List<Object?> get props => [];
}

class PatchAvailable extends PatchState {
  final int patchNumber;
  PatchAvailable(this.patchNumber);
  @override
  List<Object?> get props => [patchNumber];
}

class PatchCheckFailed extends PatchState {
  @override
  List<Object?> get props => [];
}
