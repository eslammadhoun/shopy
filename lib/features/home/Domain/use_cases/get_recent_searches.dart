import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/recent_search.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetRecentSearches {
  final FirebaseRepository firebaseRepository;
  const GetRecentSearches({required this.firebaseRepository});

  Future<Either<Failure, Stream<List<RecentSearch>>>> call() {
    return firebaseRepository.getRecentSearchesStream();
  }
}