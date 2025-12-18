import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/group.dart';
import '../repositories/chat_repository.dart';

class SearchGroups implements UseCase<List<Group>, SearchGroupsParams> {
  final ChatRepository repository;

  SearchGroups(this.repository);

  @override
  Future<Either<Failure, List<Group>>> call(SearchGroupsParams params) async {
    return await repository.searchGroups(params.keyword);
  }
}

// Params class
class SearchGroupsParams {
  final String keyword;

  const SearchGroupsParams({required this.keyword});
}