import 'package:dartz/dartz.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../datasources/local/authentication_local_datasource.dart';
import '../datasources/remote/authentication_remote_datasource.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;

  AuthenticationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final remoteUser = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(remoteUser);
      return Right(remoteUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String fullName, String password) async {
    try {
      final remoteUser = await remoteDataSource.register(email, fullName, password);
      await localDataSource.cacheUser(remoteUser);
      return Right(remoteUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCachedUser();
      return const Right(unit);
    } on ServerException {
      return const Left(ServerFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Thử remote trước
      final remoteUser = await remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      }
    } on ServerException {
      // Fallback local nếu remote fail (offline)
    }

    try {
      final localUser = await localDataSource.getCachedUser();
      return Right(localUser);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message ?? 'Cache error'));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }
}