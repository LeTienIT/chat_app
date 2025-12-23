import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_bloc.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_event.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverGroupPge extends StatefulWidget{
  const DiscoverGroupPge({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DiscoverGroupPge();
  }
}
class _DiscoverGroupPge extends State<DiscoverGroupPge>{
  final TextEditingController _searchController = TextEditingController();

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

                    });
                  },
                ),
              ),
              onChanged: (query){
                if(query!=null || query.isNotEmpty){
                  context.read<DiscoverGroupBloc>().add(SearchGroupEvent(query));
                }
              }
          ),
        ),

        Expanded(
          child: BlocConsumer<DiscoverGroupBloc, DiscoverGroupState>(
              listener: (context, state){
                if(state is DiscoverGroupErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state){
                if(state is DiscoverGroupLoadingState){
                  return Center(child: const CircularProgressIndicator(),);
                }
                else if(state is DiscoverGroupSearchedState){
                  final data = state.groups;
                  if(data.isEmpty){
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
                      itemCount: data.length,
                      itemBuilder: (context, idx){
                        final group = data[idx];
                        final memberCount = group.members.length;
                        final isJoined = group.members.contains(userId);
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
                            trailing: isJoined ?
                            Icon(Icons.star, color: Colors.amber,) :
                            IconButton(
                                onPressed: (){
                                  context.read<DiscoverGroupBloc>().add(JoinGroupEvent(groupId: group.id, userId: userId));
                                },
                                icon: Icon(Icons.add)
                            ),

                            onTap: (){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vào tin nhắn")));
                            },
                          ),
                        );
                      }
                  );
                }
                return SizedBox();
              }
          ),
        )
      ],
    );
  }
}