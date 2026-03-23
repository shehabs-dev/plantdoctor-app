import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class AuthStateChangesUsecase {
  final Repository repository;

  AuthStateChangesUsecase({required this.repository});

  Stream<Either<Failure, UserEntity?>> call() {
    return repository.authStateChanges;
  }
}
