import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/repository.dart';

class SendEmailVerificationUsecase {
  final Repository repository;

  SendEmailVerificationUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.sendEmailVerification();
  }
}
