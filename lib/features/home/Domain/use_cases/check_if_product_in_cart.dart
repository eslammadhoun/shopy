import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class CheckIfProductInCart {
  final FirebaseRepository firebaseRepository;
  const CheckIfProductInCart({required this.firebaseRepository});

  Future<Either<Failure, bool>> call({required String productId}) {
    return firebaseRepository.checkIfProductInCart(productId: productId);
  }
}