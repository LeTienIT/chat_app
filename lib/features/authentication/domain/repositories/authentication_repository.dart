import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthenticationRepository {
  // Login/Register
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String fullName, String password);

  // Logout & Current User
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> authStateChanges();
}