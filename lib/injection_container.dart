
import 'package:chat_app/features/groups/data/datasources/group_datasource.dart';
import 'package:chat_app/features/groups/data/datasources/group_datasource_impl.dart';
import 'package:chat_app/features/groups/data/repositories/group_repository_impl.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:chat_app/features/groups/domain/usecase/join_group.dart';
import 'package:chat_app/features/groups/domain/usecase/load_group.dart';
import 'package:chat_app/features/groups/domain/usecase/search_group.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_bloc.dart';
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
import 'features/groups/domain/usecase/create_group.dart';

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

  sl.registerLazySingleton<GroupDatasource>(() => GroupRemoteDataSourceImpl(sl(),));

  sl.registerLazySingleton<GroupRepository>(()=>GroupRepositoryImpl(groupDatasource: sl()));

  sl.registerLazySingleton(() => LoadMyGroup(groupRepository: sl()));
  sl.registerLazySingleton(() => CreateGroup(groupRepository: sl()));
  sl.registerLazySingleton(() => JoinGroup(repository: sl()));
  sl.registerLazySingleton(() => SearchGroup(groupRepository: sl()));

  sl.registerFactory(() => MyGroupBloc(loadMyGroup: sl(), createGroup: sl()),);
}