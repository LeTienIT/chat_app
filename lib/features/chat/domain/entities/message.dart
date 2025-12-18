import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String groupId;
  final String senderId;
  final String content;  // Text hoặc URL voice sau
  final DateTime timestamp;
  final Map<String, bool>? readBy;  // Optional: {userId: true} cho unread

  const Message({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.readBy,
  });

  @override
  List<Object?> get props => [id, groupId, senderId, content, timestamp, readBy];
}