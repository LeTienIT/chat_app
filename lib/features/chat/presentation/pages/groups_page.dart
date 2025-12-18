import 'package:chat_app/features/chat/presentation/bloc/group_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/group_events.dart';
import 'package:chat_app/features/chat/presentation/bloc/group_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/group.dart';

class GroupPage extends StatefulWidget{
  const GroupPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return _GroupPage();
  }
}

class _GroupPage extends State<GroupPage>{
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  List<Group> _filteredGroups = [];
  String _searchQuery = '';

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
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return BlocProvider(
      create: (_)=>sl<GroupBloc>()..add(LoadGroups(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search....",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: (){
                  _searchController.clear();
                  setState(() {
                    _searchQuery = "";
                    _filteredGroups = [];
                  });
                },
              ),
            ),
            onChanged: (query){
              setState(() {
                _searchQuery = query.toLowerCase();
              });

              if(_currentIndex == 0){
                final state = context.read<GroupBloc>().state;
                if(state is GroupLoaded){
                  _filteredGroups = state.groups.where(
                          (g) => g.name.toLowerCase().contains(_searchQuery) ||
                              (g.description ?? "").toLowerCase().contains(_searchQuery))
                      .toList();
                }
              }
            },
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
          //   PAGE 0
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state){
                if(state is GroupLoading){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(state is GroupLoaded){
                  final displayGroups = _searchQuery.isEmpty ? state.groups : _filteredGroups;

                  if(displayGroups.isEmpty){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.groups, size: 64, color: Colors.grey,),
                          const SizedBox(height: 16,),
                          Text("Không có nhóm nào cả!"),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: displayGroups.length,
                      itemBuilder: (context, idx){
                        final group = displayGroups[idx];
                        final memberCount = group.members.length;
                        final isCreator = group.creatorId == userId;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(group.name.substring(0,1).toUpperCase(),style: TextStyle(color: Colors.white),),
                            ),
                            title: Text(group.name,style: TextStyle(fontWeight: FontWeight.bold),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(group.description != null )...[
                                  Text(group.description!),
                                  SizedBox(height: 16,),
                                ],
                                Text("${memberCount} members - ${isCreator ? "Đã tạo" : "Đã tham gia"}")
                              ],
                            ),
                            trailing: isCreator ? Icon(Icons.star, color: Colors.amber,) : null,
                            onTap: (){
                            //   Press -> go to feature list message
                            },
                          ),
                        );
                      }
                  );
                }
                else if(state is GroupError){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Lỗi: ${state.message}"),
                        ElevatedButton(
                            onPressed: (){
                              context.read<GroupBloc>().add(LoadGroups(userId));
                            },
                            child: Text("Thử lại")
                        )
                      ],
                    ),
                  );
                }
                return Center(child: Text('Ấn để tải danh sách nhóm'));
              },
            ),

          //   PAGE 1
            BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state){
                  return Center(child: Text('Ấn để tải danh sách nhóm'));
                }
            ),
          ],
        ),
        bottomNavigationBar:  BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Nhóm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Tìm kiếm',
              ),
            ]
        ),
        floatingActionButton: _currentIndex == 0
        ? FloatingActionButton.extended(
            onPressed: (){
            //   Chuyển sang page tạo mới sau đó load lại danh sách
            },
            label: const Text("Tạo"),
            icon: Icon(Icons.add),
        ) : null,
      ),
    );
  }
}