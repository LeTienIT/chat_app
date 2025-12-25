import 'package:chat_app/features/groups/domain/entities/group.dart';

class GroupModel extends Group{
  const GroupModel({
    required super.id,
    required super.name,
    required super.members,
    required super.creatorId,
    required super.createdAt,
    required super.updateAt,
    super.description,
    super.lastMessage});

  factory GroupModel.fromJson(Map<String, dynamic> json, String id) {
    return GroupModel(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String?,
      members: List<String>.from(json['members'] ?? []),
      creatorId: json['creatorId'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updateAt: DateTime.parse(json['updateAt']),
      lastMessage: json['lastMessage'] as String?,
    );
  }

  Group toEntity() {
    return Group(
      id: id,
      name: name,
      description: description,
      members: members,
      creatorId: creatorId,
      createdAt: createdAt,
      updateAt: updateAt,
      lastMessage: lastMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'members': members,
      'creatorId': creatorId,
      'createdAt': createdAt.toIso8601String(),
      'updateAt' : updateAt.toIso8601String(),
      'lastMessage': lastMessage,
    };
  }

}