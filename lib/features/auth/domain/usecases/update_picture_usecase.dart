import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/repository.dart';

class UpdatePictureUsecase {
  final Repository _repository;

  UpdatePictureUsecase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String userId,
    required File image,
  }) => _repository.updatePicture(userId: userId, image: image);
}
