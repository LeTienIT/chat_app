import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/domain/usecases/create_group.dart';
import 'package:chat_app/features/chat/domain/usecases/get_user_groups.dart';
import 'package:chat_app/features/chat/domain/usecases/search_group.dart';
import 'package:chat_app/features/chat/presentation/bloc/group_events.dart';
import 'package:chat_app/features/chat/presentation/bloc/group_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/usecases/join_group.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState>{
  GetUserGroup getUserGroup;
  CreateGroup createGroup;
  JoinGroup joinGroup;
  SearchGroups searchGroups;

  GroupBloc({
    required this.getUserGroup,
    required this.createGroup,
    required this.joinGroup,
    required this.searchGroups,
  }) : super(GroupInitial()){
    on<LoadGroups>(_onAppLoaded);
    on<CreateGroupE>(_onCreateGroup);
    on<JoinGroupE>(_onJoinGroup);
    on<SearchGroupsE>(_onSearchGroups);
  }

  Future<void> _onAppLoaded(LoadGroups event, Emitter<GroupState> emit) async{
    emit(GroupLoading());

    final data = await getUserGroup(event.userId);

    data.fold(
        (failure){
          emit(GroupError(failure.message));
        },
        (groups){
          emit(GroupLoaded(groups));
        }
    );
  }

  Future<void> _onCreateGroup(CreateGroupE event, Emitter<GroupState> emit) async {
    emit(GroupLoading());

    final result = await createGroup(
      CreateGroupParams(name: event.name, members: event.members , creatorId: event.members.first)
    );

    result.fold(
        (failure) {
          emit(GroupError(failure.message));
        },
        (_) {
          add(LoadGroups(event.members.first));
        },
    );
  }

  Future<void> _onJoinGroup(JoinGroupE event, Emitter<GroupState> emit) async{
    emit(GroupLoading());

    final result = await joinGroup(
      JoinGroupParams(
        groundId: event.groupId,
        uId: event.userId
      ),
    );

    result.fold(
          (failure) => emit(GroupError(failure.message)),
          (_) => add(LoadGroups(event.userId)),
    );

  }

  Future<void> _onSearchGroups(SearchGroupsE event, Emitter<GroupState> emit) async {
    if (event.keyword.isEmpty) {
      add(LoadGroups(FirebaseAuth.instance.currentUser?.uid ?? ''));  // Hoặc từ param
      return;
    }

    emit(GroupLoading());

    final result = await searchGroups(SearchGroupsParams(keyword: event.keyword));

    result.fold(
          (failure) => emit(GroupError(failure.message)),
          (groups) => emit(GroupSearched(groups)),
    );
  }
}