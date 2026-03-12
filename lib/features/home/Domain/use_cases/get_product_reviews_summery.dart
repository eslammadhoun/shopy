import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetProductReviewsSummery {
  final FirebaseRepository firebaseRepository;
  const GetProductReviewsSummery({required this.firebaseRepository});

  Either<Failure, Stream<Map<String, dynamic>>> call({required String productId}) {
    return firebaseRepository.getProductReviewsSummery(productId: productId);
  }
}