class ServerException implements Exception {}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class AuthException implements Exception {
  final String code;
  const AuthException({required this.code});
}
