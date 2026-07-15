import '../../domain/entities/patch_info.dart';

class PatchInfoModel extends PatchInfo {
  const PatchInfoModel({required super.patchNumber, required super.isNewPatch});

  factory PatchInfoModel.fromCurrentPatch({
    required int? currentPatch,
    required int? lastSeenPatch,
  }) {
    if (currentPatch == null) {
      return const PatchInfoModel(patchNumber: null, isNewPatch: false);
    }
    return PatchInfoModel(
      patchNumber: currentPatch,
      isNewPatch: lastSeenPatch == null || currentPatch > lastSeenPatch,
    );
  }
}
