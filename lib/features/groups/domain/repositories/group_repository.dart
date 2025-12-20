import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:dartz/dartz.dart';

abstract class GroupRepository{
  Future<Either<Failure, List<Group>>> loadMyGroups(String uID);

  Future<Either<Failure, Group>> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorID,
  });

  Future<Either<Failure, Unit>> joinGroup({required String groupId, required String userId,});

  Future<Either<Failure, List<Group>>> searchGroup(String query);
}