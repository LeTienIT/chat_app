import 'package:chat_app/core/error/exceptions.dart';
import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/features/chat/data/datasource/message_datasource.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:chat_app/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';

class MessageRepositoryImpl implements MessageRepository{
  final MessageDataSource messageDataSource;

  MessageRepositoryImpl(this.messageDataSource);

  @override
  Future<Either<Failure, String>> sendMessage(Message message) async {
    try{
      final model = MessageModel(
          id: message.id,
          groupId: message.groupId,
          senderId: message.senderId,
          content: message.content,
          type: message.type,
          createdAt: message.createdAt,
          senderName: message.senderName
      );

      final newId = await messageDataSource.sendMessage(model);

      return Right(newId);
    }
    on ServerException catch (e){
      return Left(ServerFailure("Gửi tin nhắn thất bại."));
    }
    catch (e){
      return  Left(ServerFailure("Error: $e"));
    }
  }

  @override
  Stream<List<Message>> streamMessage(String groupId) {
    return messageDataSource.streamMessages(groupId);
  }

  @override
  Future<Either<Failure, List<Message>>> loadMoreMessages({required String groupId, required Message lastMessage}) async {
    try{
      final lastDoc = await messageDataSource.getMessageSnapshot(groupId: groupId, messageId: lastMessage.id,);

      final models = await messageDataSource.loadMoreMessages(groupId: groupId, lastDoc: lastDoc,);

      return Right(models);
    }
    on ServerException catch (e){
      return Left(ServerFailure("Đã xảy ra lỗi từ server"));
    }
    catch (e){
      return Left(ServerFailure("Đã xảy ra lỗi"));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMessage(String groupId, String messageId) async {
    try{
      await messageDataSource.deleteMessage(groupId, messageId);
      return Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure("Lỗi"));
    }
    catch(e){
      return Left(ServerFailure("Error: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> cleanActionGroup(String userId) async {
    try{
      await messageDataSource.cleanActionGroup(userId);
      return Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure("Server lỗi"));
    }
    catch(e){
      return Left(ServerFailure("Error: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> setActionGroup(String groupId, String userId) async {
    try{
      await messageDataSource.setActionGroup(groupId, userId);
      return Right(unit);
    }
    on ServerException catch(e){
      return Left(ServerFailure("Server lỗi"));
    }
    catch(e){
      return Left(ServerFailure("Error: $e"));
    }
  }



}