import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/repository.dart';

class SignOutUsecase {
  final Repository repository;

  SignOutUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
