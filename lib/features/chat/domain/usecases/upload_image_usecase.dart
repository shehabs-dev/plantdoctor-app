import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class UploadImageUsecase {
  final ChatRepository _repository;
  const UploadImageUsecase(this._repository);

  Future<Either<Failure, String>> call(File image) =>
      _repository.uploadImage(image);
}
