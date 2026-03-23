import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class GetUserDataUsecase {
  final Repository repository;

  GetUserDataUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await repository.getUserData(userId);
  }
}
