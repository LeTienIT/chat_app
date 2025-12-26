import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class SetActionGroupParams{
  String groupId;
  String userId;

  SetActionGroupParams(this.groupId, this.userId);
}

class SetActionGroup implements UseCase<Unit, SetActionGroupParams>{
  final MessageRepository messageRepository;

  SetActionGroup(this.messageRepository);

  @override
  Future<Either<Failure, Unit>> call(SetActionGroupParams params) {
    return messageRepository.setActionGroup(params.groupId, params.userId);
  }


}