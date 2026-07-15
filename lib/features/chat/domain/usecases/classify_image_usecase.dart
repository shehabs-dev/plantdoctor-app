import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class ClassifyImageUsecase {
  final ChatRepository _repository;
  const ClassifyImageUsecase(this._repository);

  Future<Either<Failure, (String, double)>> call(File image) async {
    final result = await _repository.classifyImage(image);
    return result;
  }
}
