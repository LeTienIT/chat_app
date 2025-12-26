import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository{
  Stream<List<Message>> streamMessage(String groupId);

  Future<Either<Failure, String>> sendMessage(Message message);

  Future<Either<Failure, List<Message>>> loadMoreMessages({ required String groupId, required Message lastMessage});

  Future<Either<Failure, Unit>> deleteMessage(String groupId, String messageId);

  Future<Either<Failure, Unit>> setActionGroup(String groupId, String userId);

  Future<Either<Failure, Unit>> cleanActionGroup(String userId);
}