import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class PreloadChatDataUsecase {
  final ChatRepository _repository;
  const PreloadChatDataUsecase(this._repository);

  Future<Either<Failure, void>> call(String userId) => _repository.preload(userId);
}
