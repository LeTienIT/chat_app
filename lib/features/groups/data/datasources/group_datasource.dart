import 'package:dartz/dartz.dart';

import '../../../groups/data/models/group_model.dart';

abstract class GroupDatasource{

  Future<GroupModel> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorId,
  });

  Future<List<GroupModel>> loadUserGroups(String userId);

  Future<void> joinGroup({
    required String groupId,
    required String userId,
  });

  Future<List<GroupModel>> searchGroups(String query);

  Future<Unit> updateGroupName(String groupId, String newGroupName);

  Future<Unit> deleteGroup(String groupId);

  Stream<List<GroupModel>> listenMyGroups(String userId);
}