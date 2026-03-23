import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_provider.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class SignInWithProviderUsecase {
  final Repository repository;

  SignInWithProviderUsecase({required this.repository});

  Future<Either<Failure, UserEntity>> call(AppAuthProvider provider) async {
    return await repository.signInWithProvider(provider: provider);
  }
}
