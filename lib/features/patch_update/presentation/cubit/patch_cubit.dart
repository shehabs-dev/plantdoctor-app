import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_for_new_patch_usecase.dart';
import '../../domain/usecases/mark_patch_seen_usecase.dart';
part 'patch_state.dart';

class PatchCubit extends Cubit<PatchState> {
  final CheckForNewPatchUsecase _checkForNewPatchUsecase;
  final MarkPatchSeenUsecase _markPatchSeenUsecase;

  PatchCubit({
    required CheckForNewPatchUsecase checkForNewPatchUsecase,
    required MarkPatchSeenUsecase markPatchSeenUsecase,
  }) : _checkForNewPatchUsecase = checkForNewPatchUsecase,
       _markPatchSeenUsecase = markPatchSeenUsecase,
       super(PatchInitial());

  Future<void> checkForNewPatch() async {
    emit(PatchChecking());
    final result = await _checkForNewPatchUsecase();

    if (isClosed) return;

    result.fold((_) => emit(PatchCheckFailed()), (patchInfo) {
      if (patchInfo.isNewPatch && patchInfo.patchNumber != null) {
        emit(PatchAvailable(patchInfo.patchNumber!));
      } else {
        emit(PatchUpToDate());
      }
    });
  }

  Future<void> markCurrentPatchAsSeen(int patchNumber) async {
    await _markPatchSeenUsecase(patchNumber);
  }
}
