import 'package:shorebird_code_push/shorebird_code_push.dart';
import '../../../../core/errors/exceptions.dart';

abstract class PatchRemoteDataSource {
  Future<Patch?> getCurrentPatch();
}

class PatchRemoteDataSourceImpl implements PatchRemoteDataSource {
  const PatchRemoteDataSourceImpl({required ShorebirdUpdater updater})
    : _updater = updater;

  final ShorebirdUpdater _updater;

  @override
  Future<Patch?> getCurrentPatch() async {
    try {
      return await _updater.readCurrentPatch();
    } catch (_) {
      throw ServerException();
    }
  }
}
