import 'package:fpdart/fpdart.dart';
import 'package:plantdoctor/features/auth/domain/entities/user_entity.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/repository.dart';

class SignInUsecase {
  final Repository repository;

  SignInUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    return await repository.signIn(email: email, password: password);
  }
}
