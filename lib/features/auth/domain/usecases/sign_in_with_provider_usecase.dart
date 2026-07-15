import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_provider.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class SignInWithProviderUsecase {
  final Repository _repository;
  SignInWithProviderUsecase({required Repository repository})
    : _repository = repository;

  Future<Either<Failure, UserEntity>> call(
    AppAuthProvider provider, {
    void Function()? onAccountSelected,
  }) => _repository.signInWithProvider(
    provider: provider,
    onAccountSelected: onAccountSelected,
  );
}
