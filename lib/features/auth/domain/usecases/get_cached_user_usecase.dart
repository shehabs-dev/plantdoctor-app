import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class GetCachedUserUsecase {
  final Repository repository;
  GetCachedUserUsecase({required this.repository});

  Future<UserEntity?> call() => repository.getCachedUser();
}
