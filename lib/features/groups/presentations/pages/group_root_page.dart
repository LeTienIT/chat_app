import 'package:chat_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_bloc.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_state.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_event.dart';
import 'package:chat_app/features/groups/presentations/pages/discover_groups_page/discover_group.dart';
import 'package:chat_app/features/groups/presentations/pages/my_groups_page/my_group.dart';
import 'package:chat_app/presentation/shared/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/my_group_bloc/my_group_bloc.dart';
import 'my_groups_page/create_group_sheet.dart';

class GroupRootPage extends StatefulWidget{
  const GroupRootPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroupRootPage();
  }
}

class _GroupRootPage extends State<GroupRootPage>{
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscoverGroupBloc, DiscoverGroupState>(
      listener: (context, state){
        if(state is DiscoverGroupJoinedState){
          context.read<MyGroupBloc>().add(LoadMyGroupEvent(state.uId));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nhóm chat"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        drawer: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state){
            if(state is AuthLoading) return const Drawer(child: Center(child: CircularProgressIndicator(),),);
            if(state is AuthAuthenticated){
              return MenuShared(user: state.user);
            }
            return const Drawer(child: Text("Chưa login"),);
          },
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            MyGroupPage(),
            DiscoverGroupPge()
          ],
        ),
        floatingActionButton:  (_currentIndex == 0) ?
        FloatingActionButton(
          onPressed: () {
            final myGroupBloc = context.read<MyGroupBloc>();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => BlocProvider.value(
                value: myGroupBloc,
                child: const CreateGroupBottomSheet(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ) : null,
        bottomNavigationBar: BottomNavigationBar(
            currentIndex:  _currentIndex,
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.groups), label: "Nhóm"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore), label: "Tham gia"
              )
            ]
        ),
      ),
    );
  }
}