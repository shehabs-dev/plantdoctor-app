import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class SetUserDataUsecase {
  final Repository repository;

  SetUserDataUsecase({required this.repository});

  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.setUserData(user);
  }
}
