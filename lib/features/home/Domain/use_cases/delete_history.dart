import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class DeleteSearchHistory {
  final FirebaseRepository firebaseRepository;
  const DeleteSearchHistory({required this.firebaseRepository});

  Future<Either<Failure, void>> call() {
    return firebaseRepository.deleteSearchHistory();
  }
}