import 'package:equatable/equatable.dart';
import '../../domain/entities/group.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupLoaded extends GroupState {
  final List<Group> groups;

  const GroupLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GroupSearched extends GroupState {
  final List<Group> groups;

  const GroupSearched(this.groups);

  @override
  List<Object?> get props => [groups];
}

class GroupError extends GroupState {
  final String message;

  const GroupError(this.message);

  @override
  List<Object?> get props => [message];
}
