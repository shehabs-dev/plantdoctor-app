import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';

abstract class PatchLocalDataSource {
  Future<int?> getLastSeenPatch();
  Future<void> saveLastSeenPatch(int patchNumber);
}

class PatchLocalDataSourceImpl implements PatchLocalDataSource {
  final SharedPreferences _prefs;
  static const _key = 'last_seen_patch';

  PatchLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<int?> getLastSeenPatch() async {
    try {
      return _prefs.getInt(_key);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveLastSeenPatch(int patchNumber) async {
    try {
      await _prefs.setInt(_key, patchNumber);
    } catch (_) {
      throw CacheException();
    }
  }
}
