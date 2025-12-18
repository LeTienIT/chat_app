import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

class JoinGroupParams {
  final String groupId;
  final String userId;

  const JoinGroupParams({
    required this.groupId,
    required this.userId,
  });
}

class JoinGroup implements UseCase<Unit, JoinGroupParams> {
  final GroupRepository repository;

  JoinGroup({required this.repository});

  @override
  Future<Either<Failure, Unit>> call(JoinGroupParams params) {
    return repository.joinGroup(
      groupId: params.groupId,
      userId: params.userId,
    );
  }
}
