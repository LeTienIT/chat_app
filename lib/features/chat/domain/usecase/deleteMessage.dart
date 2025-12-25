import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteMessageParams{
  String groupId;
  String messageId;

  DeleteMessageParams(this.groupId, this.messageId);
}

class DeleteMessage implements UseCase<Unit, DeleteMessageParams>{
  final MessageRepository messageRepository;
  DeleteMessage(this.messageRepository);
  @override
  Future<Either<Failure, Unit>> call(DeleteMessageParams params) {
    return messageRepository.deleteMessage(params.groupId, params.messageId);
  }

}