import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:equatable/equatable.dart';

abstract class DiscoverGroupState extends Equatable{
  const DiscoverGroupState();

  @override
  List<Object?> get props => [];
}

class DiscoverGroupInitialState extends DiscoverGroupState{}

class DiscoverGroupLoadingState extends DiscoverGroupState{}

class DiscoverGroupSearchedState extends DiscoverGroupState{
  final List<Group> groups;

  const DiscoverGroupSearchedState(this.groups);

  @override
  List<Object?> get props => [groups];
}

class DiscoverGroupErrorState extends DiscoverGroupState{
  String message;

  DiscoverGroupErrorState(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class DiscoverGroupJoinedState extends DiscoverGroupState{
  String uId;

  DiscoverGroupJoinedState(this.uId);
}