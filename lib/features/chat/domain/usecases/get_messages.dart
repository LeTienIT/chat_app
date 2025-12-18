import 'package:dartz/dartz.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/error/failures.dart';

class GetMessages{
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Stream<Either<Failure, List<Message>>> call(String groupId) {
    return repository.getMessagesStream(groupId);
  }
}