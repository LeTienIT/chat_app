import 'package:chat_app/core/error/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';
import 'message_datasource.dart';

class MessageDataSourceImpl implements MessageDataSource {
  final FirebaseFirestore firestore;

  MessageDataSourceImpl(this.firestore);

  @override
  Stream<List<MessageModel>> streamMessages(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
          MessageModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<DocumentSnapshot> getMessageSnapshot({required String groupId, required String messageId,}) async {
    try{
      final doc = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .doc(messageId)
          .get();

      if (!doc.exists) {
        throw ServerException(message: 'Last message not found');
      }

      return doc;
    }
    catch (e){
      if(e is ServerException){
        rethrow;
      }
      else{
        throw ServerException(message: "Error $e");
      }
    }
  }

  @override
  Future<List<MessageModel>> loadMoreMessages({required String groupId, required DocumentSnapshot lastDoc,}) async {
    try{
      final snapshot = await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDoc)
          .limit(30)
          .get();

      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
          .toList();
    }
    catch (e){
      throw ServerException(message: "Error: $e");
    }
  }

  @override
  Future<String> sendMessage(MessageModel message) async {
    try{
      final messageRef = firestore
          .collection('groups')
          .doc(message.groupId)
          .collection('messages')
          .doc();
      final newId = messageRef.id;
      final updatedModel = message.copyWith(id: newId);
      await messageRef.set(updatedModel.toJson());

      // Update preview group
      // await firestore.collection('groups').doc(message.groupId).update({
      //   'lastMessage': message.content,
      //   'lastMessageAt': FieldValue.serverTimestamp(),
      // });
      return newId;
    }catch (e){
      throw ServerException(message: "Error: $e");
    }
  }
}
