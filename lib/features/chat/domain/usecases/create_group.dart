import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/group.dart';

class CreateGroup implements UseCase<Group, CreateGroupParams> {
  final ChatRepository repository;

  CreateGroup(this.repository);

  @override
  Future<Either<Failure, Group>> call(CreateGroupParams params) async {
    return await repository.createGroup(
      name: params.name,
      description: params.description,
      members: params.members,
      creatorId: params.creatorId,
    );
  }
}

class CreateGroupParams {
  final String name;
  final String? description;
  final List<String> members;
  final String creatorId;

  CreateGroupParams({
    required this.name,
    this.description,
    required this.members,
    required this.creatorId,
  });
}