import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/MessageModel.dart';
import '../models/group_model.dart';

abstract class ChatRemoteDataSource {

  Future<Either<Failure, GroupModel>> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorId,
  });

  Future<Either<Failure, List<GroupModel>>> getUserGroups(String userId);

  Future<Either<Failure, Unit>> joinGroup(String groupId, String userId);

  Future<Either<Failure, Unit>> sendMessage({
    required String groupId,
    required String senderId,
    required String content,
  });

  Stream<Either<Failure, List<MessageModel>>> getMessagesStream(String groupId);

  Future<Either<Failure, List<GroupModel>>> searchGroups(String keyword);
}