import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../models/message_model.dart';

abstract class MessageDataSource {
  Stream<List<MessageModel>> streamMessages(String groupId);

  Future<String> sendMessage(MessageModel message);

  Future<List<MessageModel>> loadMoreMessages({required String groupId, required DocumentSnapshot lastDoc,});

  Future<DocumentSnapshot> getMessageSnapshot({required String groupId, required String messageId,});

  Future<Unit> deleteMessage(String groupId, String messageId);
}
