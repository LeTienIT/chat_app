import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../models/MessageModel.dart';
import '../models/group_model.dart';
import 'chat_remote_datasource.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Either<Failure, GroupModel>> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorId,
  }) async {
    try {
      final now = DateTime.now();
      final groupData = GroupModel(
        id: '',
        name: name,
        description: description,
        members: members,
        creatorId: creatorId,
        createdAt: now,
      ).toJson()..remove('id');  // Remove id vì auto-generate

      final docRef = await firestore.collection('groups').add(groupData);
      final doc = await docRef.get();
      return Right(GroupModel.fromJson(doc.data()!..['id'] = doc.id));
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Create group failed'));
    } catch (e) {
      return Left(CacheFailure('Send message failed'));  // Hoặc ServerFailure tùy lỗi
    }
  }

  @override
  Future<Either<Failure, List<GroupModel>>> getUserGroups(String userId) async {
    try {
      final snapshot = await firestore
          .collection('groups')
          .where('members', arrayContains: userId)
          .get();

      final groups = snapshot.docs
          .map((doc) => GroupModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
      return Right(groups);
    } on FirebaseException catch (e) {
      return Left(ServerFailure( e.message ?? 'Get groups failed'));
    } catch (e) {
      return Left(CacheFailure('Send message failed'));
    }
  }

  @override
  Future<Either<Failure, Unit>> joinGroup(String groupId, String userId) async {
    try {
      await firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Join group failed'));
    } catch (e) {
      return Left(CacheFailure('Send message failed'));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String groupId,
    required String senderId,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      final messageData = MessageModel(
        id: '',  // Auto-generate
        groupId: groupId,
        senderId: senderId,
        content: content,
        timestamp: now,
        readBy: {senderId: true},  // Sender đã read
      ).toJson()..remove('id');

      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add(messageData);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Send message failed'));
    } catch (e) {
      return Left(CacheFailure('Send message failed'));
    }
  }

  @override
  Future<Either<Failure, List<GroupModel>>> searchGroups(String keyword) async {
    try {
      final snapshot = await firestore
          .collection('groups')
          .where('name', isGreaterThanOrEqualTo: keyword)
          .limit(20)
          .get();

      final groups = snapshot.docs
          .map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return GroupModel.fromJson(data);
      })
          .toList();

      return Right(groups);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Search groups failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Stream<Either<Failure, List<MessageModel>>> getMessagesStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map<Either<Failure, List<MessageModel>>>((snapshot) {
          final messages = snapshot.docs.map((doc) {
            final data = doc.data();
            (data as Map<String, dynamic>)['id'] = doc.id;
            return MessageModel.fromJson(data);
          })
          .toList();
        return Right(messages);
        })
        .handleError((error, stackTrace) {
          return Left(ServerFailure( error.toString()));
        });
  }
}