import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'features/authentication/data/datasources/remote/authentication_remote_datasource.dart';
import 'features/authentication/data/repositories/authentication_repository_impl.dart';
import 'features/authentication/domain/repositories/authentication_repository.dart';
import 'features/authentication/domain/usecases/login.dart';
import 'features/authentication/domain/usecases/register.dart';
import 'features/authentication/domain/usecases/logout.dart';
import 'features/authentication/domain/usecases/get_current_user.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // SharedPrefs
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Datasources
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSource(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );
  sl.registerLazySingleton<AuthenticationLocalDataSource>(
        () => AuthenticationLocalDataSource(),
  );

  // Repository
  sl.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(
      remoteDataSource: sl<AuthenticationRemoteDataSource>(),
      localDataSource: sl<AuthenticationLocalDataSource>(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => Login(sl<AuthenticationRepository>()));
  sl.registerLazySingleton(() => Register(sl<AuthenticationRepository>()));
  sl.registerLazySingleton(() => Logout(sl<AuthenticationRepository>()));
  sl.registerLazySingleton(() => GetCurrentUser(sl<AuthenticationRepository>()));

  // Bloc (sẽ dùng sau)
  sl.registerFactory(() => AuthBloc(login: sl(), register: sl(), logout: sl(), getCurrentUser: sl()));
}