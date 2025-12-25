import 'package:equatable/equatable.dart';

import '../../../domain/entities/group.dart';

abstract class MyGroupEvent extends Equatable{
  const MyGroupEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyGroupEvent extends MyGroupEvent{
  final String userId;

  const LoadMyGroupEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateGroupEvent extends MyGroupEvent{
  final String name;
  final String? description;
  final String creatorId;

  const CreateGroupEvent({
    required this.name,
    this.description,
    required this.creatorId
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name, description, creatorId];
}

class UpdateGroupEvent extends MyGroupEvent{
  final String groupId;
  final String newName;

  const UpdateGroupEvent({
    required this.groupId,
    required this.newName
  });
}

class DeleteGroupEvent extends MyGroupEvent{
  String groupId;
  DeleteGroupEvent(this.groupId);
}

class MyGroupStreamUpdated extends MyGroupEvent {
  final List<Group> groups;
  const MyGroupStreamUpdated(this.groups);
}

class MyGroupStreamError extends MyGroupEvent {
  final String message;
  const MyGroupStreamError(this.message);
}

