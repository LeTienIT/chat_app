import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:chat_app/features/groups/domain/usecase/create_group.dart';
import 'package:chat_app/features/groups/domain/usecase/delete_group.dart';
import 'package:chat_app/features/groups/domain/usecase/listen_my_group.dart';
import 'package:chat_app/features/groups/domain/usecase/load_group.dart';
import 'package:chat_app/features/groups/domain/usecase/updateGroupName.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_event.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_state.dart';

class MyGroupBloc extends Bloc<MyGroupEvent, MyGroupState>{
  final CreateGroup createGroup;
  final LoadMyGroup loadMyGroup;
  final UpdateGroup updateGroup;
  final DeleteGroup deleteGroup;
  final ListenMyGroup listenMyGroup;

  StreamSubscription<List<Group>>? _subscription;

  @override
  Future<void> close() async{
    await _subscription?.cancel();
    return super.close();
  }
  MyGroupBloc({required this.loadMyGroup, required this.createGroup, required this.updateGroup, required this.deleteGroup, required this.listenMyGroup}):super(MyGroupInitialState()){
    on<LoadMyGroupEvent>(_onLoadMyGroup);
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<DeleteGroupEvent>(_onDeleteGroup);
    on<MyGroupStreamUpdated>(_onStreamUpdated);
    on<MyGroupStreamError>(_onStreamError);
  }

  Future<void> _onLoadMyGroup(LoadMyGroupEvent event, Emitter<MyGroupState> emit) async {
    emit(MyGroupLoadingState());

    final rs = await loadMyGroup(LoadMyGroupParams(uId: event.userId));

    rs.fold(
        (failure) => emit(MyGroupErrorState(failure.message)),
        (groups) async {
          emit(MyGroupLoadedState(groups));
          await _subscription?.cancel();
          _subscription = listenMyGroup(event.userId).listen(
              (onGroup){
                add(MyGroupStreamUpdated(onGroup));
              },
              onError: (e){
                add(MyGroupStreamError(e.toString()));
              }
            );
        }
    );


  }

  void _onStreamUpdated(MyGroupStreamUpdated event, Emitter<MyGroupState> emit,) {
    emit(MyGroupLoadedState(event.groups));
  }

  void _onStreamError(MyGroupStreamError event, Emitter<MyGroupState> emit,) {
    emit(MyGroupErrorState(event.message));
  }

  Future<void> _onCreateGroup(CreateGroupEvent event, Emitter<MyGroupState> emit,) async {
    final currentState = state;

    if (currentState is MyGroupLoadedState) {
      emit(MyGroupCreatingState(currentState.groups));
    } else {
      emit(MyGroupLoadingState());
    }

    final rs = await createGroup(
      CreateGroupParams(
        name: event.name,
        members: [event.creatorId],
        creatorID: event.creatorId,
      ),
    );

    if (emit.isDone) return;

    if (rs.isLeft()) {
      final failure = rs.fold((l) => l, (_) => null);
      emit(MyGroupErrorState(failure!.message));
      Future.delayed(Duration(seconds: 1));
    }

    final reload = await loadMyGroup(
      LoadMyGroupParams(uId: event.creatorId),
    );

    if (emit.isDone) return;

    reload.fold(
          (ifLeft) => emit(MyGroupErrorState(ifLeft.message)),
          (ifRight) => emit(MyGroupLoadedState(ifRight)),
    );
  }

  Future<void> _onUpdateGroup(UpdateGroupEvent event, Emitter<MyGroupState> emit) async{
    final currentState = state;
    if (currentState is! MyGroupLoadedState) return;

    emit(MyGroupLoadingState());

    final rs = await updateGroup(UpdateGroupParams(groupId: event.groupId, newName: event.newName));

    rs.fold(
          (failure) {
            emit(MyGroupErrorState(failure.message));
            Future.delayed(Duration(seconds: 2));
            emit(MyGroupLoadedState(currentState.groups));
          },
          (_) {
            final updatedGroups = currentState.groups.map((group) {
              if (group.id == event.groupId) {
                return group.copyWith(
                  name: event.newName,
                  updateAt: DateTime.now(),
                );
              }
              return group;
            }).toList();

            emit(MyGroupLoadedState(updatedGroups));
          },
      );
  }

  Future<void> _onDeleteGroup(DeleteGroupEvent event, Emitter<MyGroupState> emit) async{
    final currentState = state;
    if (currentState is! MyGroupLoadedState) return;

    emit(MyGroupLoadingState());

    final rs = await deleteGroup(event.groupId);

    rs.fold(
        (failure){
          emit(MyGroupErrorState(failure.message));
        },
        (_){
          currentState.groups.removeWhere((g) => g.id == event.groupId);
          emit(MyGroupLoadedState(currentState.groups));
        }
    );
  }
}