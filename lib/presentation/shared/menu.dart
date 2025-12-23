import 'package:chat_app/features/authentication/domain/entities/user.dart';
import 'package:chat_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MenuShared extends StatefulWidget{
  final User user;
  const MenuShared({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _MenuShared();
  }
}

class _MenuShared extends State<MenuShared>{
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.blueGrey],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.person, size: 40, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.user.displayName ?? "No Name",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading:  const Icon(Icons.logout),
                  title: const Text("Đăng xuất"),
                  onTap: (){
                    context.read<AuthBloc>().add(LogoutEvent());
                    context.go('/login');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}