import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';

class SendMessage implements UseCase<Unit, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SendMessageParams prm) async {
    return await repository.sendMessage(groupId: prm.groupId, senderId: prm.senderId, content: prm.content);
  }
}

class SendMessageParams {
  String groupId;
  String senderId;
  String content;

  SendMessageParams(this.groupId, this.senderId,this.content,);
}