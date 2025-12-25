import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';

class ListenMyGroup{
  final GroupRepository groupRepository;

  ListenMyGroup(this.groupRepository);

  Stream<List<Group>> call(String userId) {
    return groupRepository.listenMyGroups(userId);
  }
}