import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/repository.dart';

class ResetPasswordUsercase {
  final Repository repository;

  ResetPasswordUsercase({required this.repository});

  Future<Either<Failure, Unit>> call(String email) {
    return repository.resetPassword(email: email);
  }
}
