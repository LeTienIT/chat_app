import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:chat_app/features/chat/domain/repositories/message_repository.dart';

class StreamMessage{
  final MessageRepository messageRepository;

  StreamMessage(this.messageRepository);

  Stream<List<Message>> call(String groupId){
    return messageRepository.streamMessage(groupId);
  }
}