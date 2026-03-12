import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class AddNewRating {
  final FirebaseRepository firebaseRepository;
  const AddNewRating({required this.firebaseRepository});

  Future<Either<Failure, void>> call({required Review review, required String productId}) async {
    return firebaseRepository.addNewRating(review: review, productId: productId);
  }
}