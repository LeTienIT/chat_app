import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/group.dart';

class GetUserGroup implements UseCase<List<Group>, String> {
  final ChatRepository repository;

  GetUserGroup(this.repository);

  @override
  Future<Either<Failure, List<Group>>> call(String uid) async {
    return await repository.getUserGroups(uid);
  }
}
