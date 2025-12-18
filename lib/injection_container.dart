import 'package:chat_app/features/chat/domain/usecases/create_group.dart';
import 'package:chat_app/features/chat/domain/usecases/get_user_groups.dart';
import 'package:chat_app/features/chat/domain/usecases/join_group.dart';
import 'package:chat_app/features/chat/domain/usecases/search_group.dart';
import 'package:chat_app/features/chat/presentation/bloc/group_bloc.dart';
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
import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/datasources/chat_remote_datasource_impl.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // SharedPrefs
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Datasources
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSource(
      firebaseAuth: FirebaseAuth.instance,
      firestore: sl(),
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

  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatRemoteDataSourceImpl( firestore: sl(),));

  sl.registerLazySingleton<ChatRepository>(()=>ChatRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => GetUserGroup(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => JoinGroup(sl()));
  sl.registerLazySingleton(() => SearchGroups(sl()));
  sl.registerFactory(() => GroupBloc(
      getUserGroup: sl(),
      createGroup: sl(),
      joinGroup: sl(),
      searchGroups: sl()
    ),
  );
}