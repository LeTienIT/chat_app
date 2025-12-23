import 'package:bloc/bloc.dart';
import 'package:chat_app/features/groups/domain/usecase/create_group.dart';
import 'package:chat_app/features/groups/domain/usecase/load_group.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_event.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_state.dart';

class MyGroupBloc extends Bloc<MyGroupEvent, MyGroupState>{
  final CreateGroup createGroup;
  final LoadMyGroup loadMyGroup;

  MyGroupBloc({required this.loadMyGroup, required this.createGroup}):super(MyGroupInitialState()){
    on<LoadMyGroupEvent>(_onLoadMyGroup);
    on<CreateGroupEvent>(_onCreateGroup);
  }

  Future<void> _onLoadMyGroup(LoadMyGroupEvent event, Emitter<MyGroupState> emit) async {
    emit(MyGroupLoadingState());

    final rs = await loadMyGroup(LoadMyGroupParams(uId: event.userId));

    rs.fold(
        (failure) => emit(MyGroupErrorState(failure.message)),
        (groups) => emit(MyGroupLoadedState(groups))
    );

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

}