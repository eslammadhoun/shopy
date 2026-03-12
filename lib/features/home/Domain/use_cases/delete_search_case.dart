import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class DeleteSearchCase {
  final FirebaseRepository firebaseRepository;
  const DeleteSearchCase({required this.firebaseRepository});

  Future<Either<Failure, bool>> call({required String searchCaseId}) async {
    return firebaseRepository.deleteSearchCase(searchCaseId: searchCaseId);
  }
}