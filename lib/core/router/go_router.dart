import 'package:chat_app/features/authentication/presentation/pages/login_page.dart';
import 'package:chat_app/features/authentication/presentation/pages/register_page.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/chat/presentation/page/chat_page.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_bloc.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_event.dart';
import 'package:chat_app/features/groups/presentations/pages/group_root_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
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
                updateGroup: sl(),
                deleteGroup: sl(),
                listenMyGroup: sl(),
              )..add(LoadMyGroupEvent(userId)),
            ),
            BlocProvider(
                create: (_) => DiscoverGroupBloc(
                    joinGroup: sl(),
                    searchGroup: sl()
                )
            )
          ],
          child: const GroupRootPage(),
        );
      },
    ),

    GoRoute(
      path: '/chat/:groupId/:groupName',
      builder: (context, state) {
        final groupId = state.pathParameters['groupId']!;
        final groupName = state.pathParameters['groupName']!;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<ChatBloc>()..add(ChatStartedEvent(groupId))
            ),
          ],
          child: ChatPage(groupId: groupId, groupName: groupName),
        );
      },
    ),
  ]
);