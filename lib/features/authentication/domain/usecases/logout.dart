import 'package:dartz/dartz.dart';
import '../repositories/authentication_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';

class Logout implements UseCase<Unit, NoParams> {
  final AuthenticationRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await repository.logout();
  }
}