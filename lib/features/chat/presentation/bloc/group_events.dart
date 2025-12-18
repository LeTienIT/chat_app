import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroups extends GroupEvent {
  final String userId;

  const LoadGroups(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateGroupE extends GroupEvent {
  final String name;
  final String? description;
  final List<String> members;

  const CreateGroupE({
    required this.name,
    this.description,
    required this.members,
  });

  @override
  List<Object?> get props => [name, description, members];
}

class JoinGroupE extends GroupEvent {
  final String groupId;
  final String userId;

  const JoinGroupE({
    required this.groupId,
    required this.userId,
  });

  @override
  List<Object?> get props => [groupId, userId];
}

class SearchGroupsE extends GroupEvent {
  final String keyword;

  const SearchGroupsE(this.keyword);

  @override
  List<Object> get props => [keyword];
}
