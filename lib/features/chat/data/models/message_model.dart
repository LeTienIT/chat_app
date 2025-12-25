import '../../domain/entities/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.groupId,
    required super.senderId,
    required super.content,
    required super.type,
    required super.createdAt,
    super.senderName
  });

  factory MessageModel.fromJson(
      Map<String, dynamic> json,
      String id,
      ) {
    return MessageModel(
      id: id,
      groupId: json['groupId'],
      senderId: json['senderId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      senderName: json['senderName'] ?? "NoName"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'senderName' : senderName,
    };
  }

  @override
  MessageModel copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    String? senderName,
  }) {
    return MessageModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      senderName: senderName ?? this.senderName
    );
  }
}
