import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/chat/domain/entities/group.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

class CreateGroup implements UseCase<Group, CreateGroupParams>{
  final GroupRepository groupRepository;

  CreateGroup({required this.groupRepository});

  @override
  Future<Either<Failure, Group>> call(CreateGroupParams params) {
    return groupRepository.createGroup(name: params.name, members: params.members, creatorID: params.creatorID, description: params.description);
  }

}

class CreateGroupParams{
  String name;
  String? description;
  List<String> members;
  String creatorID;

  CreateGroupParams({required this.name, this. description, required this.members, required this.creatorID});
}