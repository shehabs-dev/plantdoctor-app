import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class HiveEncryptionService {
  static const _keyName = 'hive_encryption_key';
  final FlutterSecureStorage _secureStorage;

  HiveEncryptionService(this._secureStorage);

  Future<HiveCipher> getEncryptionKey() async {
    final encryptionKeyString = await _secureStorage.read(key: _keyName);
    
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(
        key: _keyName,
        value: base64UrlEncode(key),
      );
      return HiveAesCipher(key);
    } else {
      final key = base64Url.decode(encryptionKeyString);
      return HiveAesCipher(key);
    }
  }
}
