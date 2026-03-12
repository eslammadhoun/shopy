import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class AddToRecentSearches {
  final FirebaseRepository firebaseRepository;
  AddToRecentSearches({required this.firebaseRepository});

  Future<Either<Failure, void>> call({required String searchQuery}) {
    return firebaseRepository.addToRecentSearches(searchQuery: searchQuery);
  }
}