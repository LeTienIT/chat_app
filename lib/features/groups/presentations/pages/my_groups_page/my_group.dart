import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/my_group_bloc/my_group_bloc.dart';
import '../../bloc/my_group_bloc/my_group_state.dart';

class MyGroupPage extends StatefulWidget{
  const MyGroupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyGroupPage();
  }
}
class _MyGroupPage extends State<MyGroupPage>{
  final TextEditingController _searchController = TextEditingController();
  List<Group> _allGroups = [];
  List<Group> _filteredGroups = [];
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
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
                    _filteredGroups = _allGroups.where((g) =>
                    g.name.toLowerCase().contains(_searchQuery) ||
                        (g.description ?? '').toLowerCase().contains(_searchQuery)
                    ).toList();
                  });
                }
            ),
          ),
          Expanded(
            child: BlocConsumer<MyGroupBloc, MyGroupState>(
                listener: (context, state) {
                  if (state is MyGroupErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state){
                  if(state is MyGroupLoadingState){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else if(state is MyGroupLoadedState){
                    _allGroups = state.groups;
                    final displayGroups = _searchQuery.isEmpty ? _allGroups : _filteredGroups;
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
                                  Text("$memberCount members")
                                ],
                              ),
                              trailing: isCreator ? Icon(Icons.star, color: Colors.amber,) : null,

                              onTap: (){
                                context.push('/chat/${group.id}/${group.name}');
                              },
                            ),
                          );
                        }
                    );
                  }
                  return const SizedBox();
                }
            ),
          )
        ],
    );
  }
}