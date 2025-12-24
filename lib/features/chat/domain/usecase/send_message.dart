import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:chat_app/features/chat/domain/repositories/message_repository.dart';
import 'package:dartz/dartz.dart';


class SendMessage implements UseCase<String, Message>{
  final MessageRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, String>> call(Message params) {
    return repository.sendMessage(params);
  }

}