import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetUserName {
  final FirebaseRepository firebaseRepository;
  const GetUserName({required this.firebaseRepository});

  Future<Either<Failure, String>> call() {
    return firebaseRepository.getUserName();
  }
}