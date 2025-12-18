import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Group>> createGroup({required String name, String? description, required List<String> members, required String creatorId,}) async {
    try {
      final result = await remoteDataSource.createGroup(
        name: name,
        description: description,
        members: members,
        creatorId: creatorId,
      );
      return result.map((model) => model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "error"));
    }
  }

  @override
  Future<Either<Failure, List<Group>>> getUserGroups(String userId) async {
    try {
      final result = await remoteDataSource.getUserGroups(userId);
      return result.map((models) => models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "error"));
    }
  }

  @override
  Future<Either<Failure, Unit>> joinGroup(String groupId, String userId) async {
    try {
      return await remoteDataSource.joinGroup(groupId, userId);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "error"));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required String groupId,
    required String senderId,
    required String content,
  }) async {
    try {
      return await remoteDataSource.sendMessage(
        groupId: groupId,
        senderId: senderId,
        content: content,
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? "error"));
    }
  }

  @override
  Future<Either<Failure, List<Group>>> searchGroups(String keyword) async {
    try {
      final result = await remoteDataSource.searchGroups(keyword);
      return result.map((models) => models.map((m) => m.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure("Lỗi tìm kiếm"));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> getMessagesStream(String groupId) {
    return remoteDataSource.getMessagesStream(groupId).map(
          (result) => result.map((models) => models.map((m) => m.toEntity()).toList()),
    );
  }


}