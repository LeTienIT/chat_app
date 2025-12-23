import 'package:equatable/equatable.dart';

abstract class DiscoverGroupEvent extends Equatable{
  const DiscoverGroupEvent();

  @override
  List<Object?> get props => [];
}

class SearchGroupEvent extends DiscoverGroupEvent{
  String query;

  SearchGroupEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class JoinGroupEvent extends DiscoverGroupEvent{
  String groupId;
  String userId;

  JoinGroupEvent({required this.groupId, required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [groupId, userId];
}

