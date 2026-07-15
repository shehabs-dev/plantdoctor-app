class ServerException implements Exception {}

class CacheException implements Exception {}

class OfflineException implements Exception {}

class AuthException implements Exception {
  final String code;
  const AuthException({required this.code});
}

class ModelException implements Exception {}

class SessionNotFoundException implements Exception {}
