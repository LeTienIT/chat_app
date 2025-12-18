import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/group.dart';

class GroupModel extends Equatable implements Group {
  @override
  final String id;

  @override
  final String name;

  @override
  final String? description;

  @override
  final List<String> members;

  @override
  final String creatorId;

  @override
  final DateTime createdAt;

  const GroupModel({required this.id, required this.name, this.description, required this.members, required this.creatorId, required this.createdAt,});

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String?,
      members: List<String>.from(json['members'] ?? []),
      creatorId: json['creatorId'] as String,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'members': members,
      'creatorId': creatorId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [id, name, description, members, creatorId, createdAt];

  Group toEntity() => Group(
    id: id,
    name: name,
    description: description,
    members: members,
    creatorId: creatorId,
    createdAt: createdAt,
  );

  @override
  Group copyWith({String? id, String? name, String? description, List<String>? members, String? creatorId, DateTime? createdAt,}) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}