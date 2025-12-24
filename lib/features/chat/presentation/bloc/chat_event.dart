import 'package:chat_app/features/chat/domain/entities/message.dart';

abstract class ChatEvent{}

class ChatStartedEvent extends ChatEvent{
  final String groupId;

  ChatStartedEvent(this.groupId);
}

class ChatMessagesUpdateEvent extends ChatEvent{
  final List<Message> messages;

  ChatMessagesUpdateEvent(this.messages);
}

class ChatLoadMoreEvent extends ChatEvent{}

class ChatSendMessageEvent extends ChatEvent{
  final Message message;

  ChatSendMessageEvent(this.message);
}