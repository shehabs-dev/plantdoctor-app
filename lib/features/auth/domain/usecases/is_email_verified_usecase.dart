import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/repository.dart';

class IsEmailVerifiedUsecase {
  final Repository repository;

  IsEmailVerifiedUsecase({required this.repository});

  Future<Either<Failure, bool>> call() async {
    return await repository.isEmailVerified();
  }
}
