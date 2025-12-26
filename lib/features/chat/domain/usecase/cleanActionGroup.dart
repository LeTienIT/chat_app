import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class CleanActionGroup implements UseCase<Unit, String>{
  final MessageRepository messageRepository;

  CleanActionGroup(this.messageRepository);

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return messageRepository.cleanActionGroup(params);
  }


}