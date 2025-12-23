import 'package:bloc/bloc.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_event.dart';
import 'package:chat_app/features/groups/presentations/bloc/discover_group_bloc/discover_group_state.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_bloc.dart';
import 'package:chat_app/features/groups/presentations/bloc/my_group_bloc/my_group_event.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecase/join_group.dart';
import '../../../domain/usecase/search_group.dart';

class DiscoverGroupBloc extends Bloc<DiscoverGroupEvent, DiscoverGroupState>{
  final JoinGroup joinGroup;
  final SearchGroup searchGroup;

  DiscoverGroupBloc({required this.joinGroup, required this.searchGroup}):super(DiscoverGroupInitialState()){
    on<SearchGroupEvent>(_onSearchMyGroup);
    on<JoinGroupEvent>(_onJoinGroup);
  }

  Future<void> _onSearchMyGroup(SearchGroupEvent event, Emitter<DiscoverGroupState> emit) async {
    emit(DiscoverGroupLoadingState());

    final rs = await searchGroup(SearchGroupParams(query: event.query));

    rs.fold(
            (failure) => emit(DiscoverGroupErrorState(failure.message)),
            (groups) => emit(DiscoverGroupSearchedState(groups))
    );

  }

  Future<void> _onJoinGroup(JoinGroupEvent event, Emitter<DiscoverGroupState> emit,) async {
    final currentState = state;

    if (currentState is! DiscoverGroupSearchedState) return;

    emit(DiscoverGroupLoadingState());

    final rs = await joinGroup(JoinGroupParams(groupId: event.groupId, userId: event.userId));

    rs.fold(
        (failure) => emit(DiscoverGroupErrorState(failure.message)),
        (_){
          final updatedGroups = currentState.groups.map((g) {
            if (g.id == event.groupId) {
              return g.copyWith(
                members: [...g.members, event.userId],
              );
            }
            return g;
          }).toList();

          emit(DiscoverGroupJoinedState(event.userId));
          emit(DiscoverGroupSearchedState(updatedGroups));

        }
    );
  }

}