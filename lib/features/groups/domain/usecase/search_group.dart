import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/groups/domain/entities/group.dart';
import 'package:chat_app/features/groups/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class SearchGroupParams{
  String query;

  SearchGroupParams({required this.query});
}

class SearchGroup implements UseCase<List<Group>, SearchGroupParams>{
  final GroupRepository groupRepository;

  SearchGroup({required this.groupRepository});

  @override
  Future<Either<Failure, List<Group>>> call(SearchGroupParams params) {
    return groupRepository.searchGroup(params.query);
  }
}