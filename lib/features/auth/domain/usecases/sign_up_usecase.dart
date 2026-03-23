import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class SignUpUsecase {
  final Repository repository;

  SignUpUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
    String name,
  ) async {
    return await repository.signUp(
      email: email,
      password: password,
      name: name,
    );
  }
}
