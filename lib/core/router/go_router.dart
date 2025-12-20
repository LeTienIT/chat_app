import 'package:chat_app/features/authentication/presentation/pages/login_page.dart';
import 'package:chat_app/features/authentication/presentation/pages/register_page.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_event.dart';
import 'package:chat_app/features/groups/presentations/pages/my_groups_page/group_root_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../injection_container.dart';
import '../../features/groups/presentations/bloc/my_group_bloc/my_group_bloc.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (c,s) => LoginPage()
    ),

    GoRoute(
        path: '/register',
        builder: (c,s) => RegisterPage()
    ),

    GoRoute(
      path: '/groups',
      builder: (context, state) {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => MyGroupBloc(
                loadMyGroup: sl(),
                createGroup: sl(),
              )..add(LoadMyGroupEvent(userId)),
            ),
          ],
          child: const GroupRootPage(),
        );
      },
    ),
  ]
);