import 'package:firebase_auth/firebase_auth.dart';

abstract class TokenProvider {
  Future<String?> getToken({bool forceRefresh = false});
}

class TokenProviderImpl implements TokenProvider {
  final FirebaseAuth _firebaseAuth;

  TokenProviderImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Future<String?> getToken({bool forceRefresh = false}) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }
}
