import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/patch_info.dart';
import '../../domain/repositories/patch_repository.dart';
import '../datasources/patch_local_data_source.dart';
import '../datasources/patch_remote_data_source.dart';
import '../models/patch_info_model.dart';

class PatchRepositoryImpl implements PatchRepository {
  const PatchRepositoryImpl({
    required PatchRemoteDataSource remoteDataSource,
    required PatchLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final PatchRemoteDataSource _remoteDataSource;
  final PatchLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, PatchInfo>> checkForNewPatch() async {
    try {
      final currentPatch = await _remoteDataSource.getCurrentPatch();

      if (currentPatch == null) {
        return right(
          const PatchInfoModel(patchNumber: null, isNewPatch: false),
        );
      }

      final lastSeenPatch = await _localDataSource.getLastSeenPatch();
      final isNewPatch =
          lastSeenPatch == null || currentPatch.number > lastSeenPatch;

      return right(
        PatchInfoModel(
          patchNumber: currentPatch.number,
          isNewPatch: isNewPatch,
        ),
      );
    } on ServerException {
      return left(ServerFailure());
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<void> markPatchAsSeen(int patchNumber) async {
    try {
      await _localDataSource.saveLastSeenPatch(patchNumber);
    } on CacheException catch (_) {
      // Not critical — silently ignore
    }
  }
}
