import 'package:equatable/equatable.dart';

enum MessageType {
  text,
  image,
  file,
}

class Message extends Equatable{
  final String id;
  final String groupId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime createdAt;

  const Message({required this.id, required this.groupId, required this.senderId, required this.type, required this.content, required this.createdAt});

  Message copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  @override
  List<Object?> get props => [id, groupId, senderId, content, createdAt, type, ];
}