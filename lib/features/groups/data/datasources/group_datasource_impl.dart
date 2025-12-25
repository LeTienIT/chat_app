import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/error/exceptions.dart';
import '../models/group_model.dart';
import 'group_datasource.dart';  // GroupModel

class GroupRemoteDataSourceImpl implements GroupDatasource {
  final FirebaseFirestore firestore;

  GroupRemoteDataSourceImpl(this.firestore);

  @override
  Future<GroupModel> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorId,
  }) async {
    try {
      final checkQuery = await firestore
          .collection('groups')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (checkQuery.docs.isNotEmpty) {
        throw ServerException(message: 'Group name "$name" already exists');
      }

      final data = {
        'name': name,
        'nameLower': name.toLowerCase(),
        'description': description,
        'members': members,
        'creatorId': creatorId,
        'createdAt': DateTime.now().toIso8601String(),
        'updateAt' : DateTime.now().toIso8601String(),
        'lastMessage' : '',
      };

      final doc = await firestore.collection('groups').add(data);
      final snap = await doc.get();

      if (!snap.exists) {
        throw ServerException(message: 'Group not created successfully');
      }
      return GroupModel.fromJson(snap.data()!, snap.id);
    } on FirebaseException catch (e) {
      String message = 'Failed to create group';
      switch (e.code) {
        case 'permission-denied':
          message = 'Permission denied to create group';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your connection';
          break;
        default:
          message = e.message ?? message;
      }
      throw ServerException(message: message);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<GroupModel>> loadUserGroups(String userId) async {
    try {
      final snap = await firestore
          .collection('groups')
          .where('members', arrayContains: userId)
          .get();

      return snap.docs
          .map((d) => GroupModel.fromJson(d.data(), d.id))
          .toList();
    } on FirebaseException catch (e) {
      String message = 'Failed to load groups';
      switch (e.code) {
        case 'permission-denied':
          message = 'Permission denied to load groups';
          break;
        case 'not-found':
          message = 'No groups found for user';
          break;
        default:
          message = e.message ?? message;
      }
      throw ServerException(message: message);
    } catch (e) {
      debugPrint('❌ Error: $e');
      debugPrint('🧱 Type: ${e.runtimeType}');
      throw ServerException(message: 'Unexpected error loading groups: $e');
    }
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    } on FirebaseException catch (e) {
      String message = 'Failed to join group';
      switch (e.code) {
        case 'permission-denied':
          message = 'You don\'t have permission to join this group';
          break;
        case 'not-found':
          message = 'Group not found';
          break;
        default:
          message = e.message ?? message;
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error joining group: $e');
    }
  }

  @override
  Future<List<GroupModel>> searchGroups(String query) async {
    try {
      final queryLower = query.toLowerCase();

      final snap = await firestore
          .collection('groups')
          .where('nameLower', isGreaterThanOrEqualTo: queryLower)
          .where('nameLower', isLessThanOrEqualTo: '$queryLower\uf8ff')
          .get();

      return snap.docs
          .map((d) => GroupModel.fromJson(d.data(), d.id))
          .toList();
    } on FirebaseException catch (e) {
      String message = 'Failed to search groups';
      switch (e.code) {
        case 'permission-denied':
          message = 'Permission denied to search groups';
          break;
        default:
          message = e.message ?? message;
      }
      throw ServerException(message: message);
    } catch (e) {
      throw ServerException(message: 'Unexpected error searching groups: $e');
    }
  }

  @override
  Future<Unit> updateGroupName(String groupId, String newGroupName) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        'name': newGroupName,
        'updateAt': DateTime.now().toIso8601String(),
      });

      return unit;
    } catch (e) {
      throw ServerException(message: "Error $e");
    }
  }

  @override
  Future<Unit> deleteGroup(String groupId) async {
    try{
      final groupRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

      final messagesSnapshot = await groupRef.collection('messages').get();

      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      await groupRef.delete();
      return(unit);
    }
    catch(e){
      throw ServerException(message: "Error $e");
    }
  }

  @override
  Stream<List<GroupModel>> listenMyGroups(String userId) {
    return firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        // .orderBy('updateAt', descending: true)
        // .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((d) => GroupModel.fromJson(d.data(), d.id))
          .toList();
    });
  }

}