import 'package:chat_app/core/error/exceptions.dart';
import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:chat_app/features/groups/data/datasources/group_datasource.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

class GroupRepositoryImpl implements GroupRepository{
  final GroupDatasource groupDatasource;

  GroupRepositoryImpl({required this.groupDatasource});

  @override
  Future<Either<Failure, Group>> createGroup({required String name, String? description, required List<String> members, required String creatorID}) async {
    try{
      final model = await groupDatasource.createGroup(name: name, members: members, creatorId: creatorID);

      return Right(model.toEntity());
    }
    on ServerException catch (e){
      return Left(ServerFailure(e.message ?? 'Failed to create group'));
    }
    catch(e){
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> joinGroup({required String groupId, required String userId}) async {
    try{
      await groupDatasource.joinGroup(groupId: groupId, userId: userId);
      return const Right((unit));
    }
    on ServerException catch (e){
      return Left(ServerFailure(e.message ?? "Failed to join group"));
    }
    catch(e){
      return Left(ServerFailure("Unexpected: $e"));
    }
  }

  @override
  Future<Either<Failure, List<Group>>> loadMyGroups(String uID) async {
    try{
      final models = await groupDatasource.loadUserGroups(uID);
      final entities = models.map((m) => m.toEntity()).toList();
      return(Right(entities));
    }
    on ServerException catch (e){
      return Left(ServerFailure(e.message ?? "Loaded to join group"));
    }
    catch(e){
      return Left(ServerFailure("Unexpected: $e"));
    }
  }

  @override
  Future<Either<Failure, List<Group>>> searchGroup(String query) async {
    try{
      final models = await groupDatasource.searchGroups(query);
      final entities = models.map((m) => m.toEntity()).toList();
      return(Right(entities));
    }
    on ServerException catch (e){
      return Left(ServerFailure(e.message ?? "Searched to join group"));
    }
    catch(e){
      return Left(ServerFailure("Unexpected: $e"));
    }
  }

}