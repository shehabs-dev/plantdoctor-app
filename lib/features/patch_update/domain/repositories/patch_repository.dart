import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/patch_info.dart';

abstract class PatchRepository {
  Future<Either<Failure, PatchInfo>> checkForNewPatch();
  Future<void> markPatchAsSeen(int patchNumber);
}
