import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class LoadMyGroupParams{
  String uId;

  LoadMyGroupParams({required this.uId});
}

class LoadMyGroup implements UseCase<List<Group>, LoadMyGroupParams>{
  final GroupRepository groupRepository;

  LoadMyGroup({required this.groupRepository});

  @override
  Future<Either<Failure, List<Group>>> call(LoadMyGroupParams params) {
    return groupRepository.loadMyGroups(params.uId);
  }
}