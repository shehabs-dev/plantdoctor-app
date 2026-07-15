import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/patch_info.dart';
import '../repositories/patch_repository.dart';

class CheckForNewPatchUsecase {
  final PatchRepository _repository;
  const CheckForNewPatchUsecase(this._repository);

  Future<Either<Failure, PatchInfo>> call() => _repository.checkForNewPatch();
}
