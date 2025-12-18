import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message.dart';

class MessageModel extends Equatable implements Message {
  @override
  final String id;

  @override
  final String groupId;

  @override
  final String senderId;

  @override
  final String content;

  @override
  final DateTime timestamp;

  @override
  final Map<String, bool>? readBy;

  const MessageModel({required this.id, required this.groupId, required this.senderId, required this.content, required this.timestamp, this.readBy,});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? '',
      groupId: json['groupId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      readBy: json['readBy'] != null
          ? Map<String, bool>.from(json['readBy'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
    };
  }

  @override
  List<Object?> get props => [id, groupId, senderId, content, timestamp, readBy];

  Message toEntity() => Message(
    id: id,
    groupId: groupId,
    senderId: senderId,
    content: content,
    timestamp: timestamp,
    readBy: readBy,
  );

  @override
  Message copyWith({String? id, String? groupId, String? senderId, String? content, DateTime? timestamp, Map<String, bool>? readBy,}) {
    return MessageModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
    );
  }
}