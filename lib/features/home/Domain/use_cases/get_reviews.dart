import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetReviews {
  final FirebaseRepository firebaseRepository;
  GetReviews({required this.firebaseRepository});

  Either<Failure, Stream<List<Review>>> call({required String productId}) {
    return firebaseRepository.getProductReviews(productId: productId);
  }
}