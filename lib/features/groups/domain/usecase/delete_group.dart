import 'package:chat_app/core/error/failures.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteGroup implements UseCase<Unit, String>{
  final GroupRepository repository;

  DeleteGroup(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteGroup(params);
  }

}