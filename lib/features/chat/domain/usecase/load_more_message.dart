import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/message_repository.dart';

class LoadMoreParams{
  String groupId;
  Message lastMessage;

  LoadMoreParams({required this.groupId, required this.lastMessage});

}
class LoadMoreMessages {
  final MessageRepository repository;

  LoadMoreMessages(this.repository);

  Future<Either<Failure, List<Message>>> call(LoadMoreParams params,) {
    return repository.loadMoreMessages(
      groupId: params.groupId,
      lastMessage: params.lastMessage,
    );
  }
}
