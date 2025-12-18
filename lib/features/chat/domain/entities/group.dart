import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<String> members;  // Array user IDs
  final String creatorId;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    this.description,
    required this.members,
    required this.creatorId,
    required this.createdAt,
  });

  // CopyWith để update entity dễ (e.g., add member)
  Group copyWith({
    String? id, String? name, String? description, List<String>? members,
    String? creatorId, DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, members, creatorId, createdAt];
}