import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences _prefs;
  static const _key = 'cached_user';

  UserLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_key, user.toJson());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final json = _prefs.getString(_key);
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  @override
  Future<void> clearCachedUser() async {
    await _prefs.remove(_key);
  }
}
