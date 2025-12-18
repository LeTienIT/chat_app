import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../groups//data/models/group_model.dart';

class GroupRemoteDataSourceImpl implements GroupDataSource {
  final FirebaseFirestore firestore;

  GroupRemoteDataSourceImpl(this.firestore);

  @override
  Future<GroupModel> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorId,
  }) async {
    final data = {
      'name': name,
      'description': description,
      'members': members,
      'creatorId': creatorId,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final doc = await firestore.collection('groups').add(data);
    final snap = await doc.get();

    return GroupModel.fromJson(snap.data()!, snap.id);
  }

  @override
  Future<List<GroupModel>> loadUserGroups(String userId) async {
    final snap = await firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .get();

    return snap.docs
        .map((d) => GroupModel.fromJson(d.data(), d.id))
        .toList();
  }

  @override
  Future<void> joinGroup({
    required String groupId,
    required String userId,
  }) async {
    await firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Future<List<GroupModel>> searchGroups(String query) async {
    final snap = await firestore
        .collection('groups')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snap.docs
        .map((d) => GroupModel.fromJson(d.data(), d.id))
        .toList();
  }
}

class GroupDataSource {
}
