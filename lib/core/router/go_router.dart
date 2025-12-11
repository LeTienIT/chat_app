import 'package:chat_app/features/authentication/presentation/pages/login_page.dart';
import 'package:chat_app/features/authentication/presentation/pages/register_page.dart';
import 'package:go_router/go_router.dart';

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
  ]
);