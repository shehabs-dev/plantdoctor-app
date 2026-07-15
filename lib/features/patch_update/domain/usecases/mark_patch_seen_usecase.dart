import '../repositories/patch_repository.dart';

class MarkPatchSeenUsecase {
  final PatchRepository _repository;
  const MarkPatchSeenUsecase(this._repository);

  Future<void> call(int patchNumber) =>
      _repository.markPatchAsSeen(patchNumber);
}
