import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateGroupParams {
  final String groupId;
  final String newName;

  const UpdateGroupParams({
    required this.groupId,
    required this.newName,
  });
}

class UpdateGroup implements UseCase<Unit, UpdateGroupParams> {
  final GroupRepository repository;

  UpdateGroup({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(UpdateGroupParams params) {
    return repository.updateNameGroup(
      params.groupId,
      params.newName,
    );
  }
}
