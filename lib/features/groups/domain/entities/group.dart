import 'package:equatable/equatable.dart';

class Group extends Equatable{
  final String id;
  final String name;
  final String? description;
  final List<String> members;  // Array user IDs
  final String creatorId;
  final DateTime createdAt;
  final DateTime updateAt;
  final String? lastMessage;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.members,
    required this.creatorId,
    required this.createdAt,
    required this.updateAt,
    this.lastMessage,
  });

  Group copyWith({String? id, String? name, String? description, List<String>? members, String? creatorId, DateTime? createdAt, DateTime? updateAt, String? lastMessage}) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      updateAt: createdAt ?? this.updateAt,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  @override
  List<Object?> get props => [id, name, description, members, creatorId, createdAt, updateAt, lastMessage];
}