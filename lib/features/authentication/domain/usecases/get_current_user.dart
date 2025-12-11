import 'package:dartz/dartz.dart';
import '../repositories/authentication_repository.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthenticationRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}