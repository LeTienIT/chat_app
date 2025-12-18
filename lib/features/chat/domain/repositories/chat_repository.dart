import 'package:dartz/dartz.dart';
import '../entities/group.dart';
import '../entities/message.dart';
import '../../../../core/error/failures.dart';

abstract class ChatRepository {
  // Groups
  Future<Either<Failure, Group>> createGroup({
    required String name,
    String? description,
    required List<String> members,
    required String creatorId,
  });
  Future<Either<Failure, List<Group>>> getUserGroups(String userId);
  Future<Either<Failure, Unit>> joinGroup(String groupId, String userId);

  Future<Either<Failure, Unit>> sendMessage({
    required String groupId,
    required String senderId,
    required String content,
  });

  Future<Either<Failure, List<Group>>> searchGroups(String keyword);

  Stream<Either<Failure, List<Message>>> getMessagesStream(String groupId);  // Real-time
}