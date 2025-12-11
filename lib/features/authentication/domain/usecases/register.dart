
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class Register implements UseCase<User, RegisterParams> {
  final AuthenticationRepository repository;

  Register(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(params.email, params.fullName, params.password);
  }
}

class RegisterParams {
  final String email;
  final String fullName;
  final String password;

  RegisterParams({required this.email, required this.fullName, required this.password});
}