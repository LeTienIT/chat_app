import 'package:dartz/dartz.dart';
import '../repositories/chat_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';

class JoinGroup implements UseCase<Unit, JoinGroupParams> {
  final ChatRepository repository;

  JoinGroup(this.repository);

  @override
  Future<Either<Failure, Unit>> call(JoinGroupParams prm) async {
    return await repository.joinGroup(prm.groundId, prm.uId);
  }
}

class JoinGroupParams {
  final String groundId;
  final String uId;

  JoinGroupParams({
    required this.groundId,
    required this.uId
  });
}