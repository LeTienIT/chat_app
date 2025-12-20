import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:equatable/equatable.dart';

abstract class MyGroupState extends Equatable{
  const MyGroupState();

  @override
  List<Object?> get props => [];
}

class MyGroupInitialState extends MyGroupState{}

class MyGroupLoadingState extends MyGroupState{}

class MyGroupLoadedState extends MyGroupState{
  final List<Group> groups;

  const MyGroupLoadedState(this.groups);

  @override
  List<Object?> get props => [groups];
}

class MyGroupErrorState extends MyGroupState {
  final String message;

  const MyGroupErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class MyGroupCreatingState extends MyGroupState{
  final List<Group> groups;

  const MyGroupCreatingState(this.groups);

  @override
  List<Object?> get props => [groups];
}