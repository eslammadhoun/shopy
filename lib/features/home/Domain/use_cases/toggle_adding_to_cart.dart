import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class ToggleAddingToCart {
  final FirebaseRepository firebaseRepository;
  const ToggleAddingToCart({required this.firebaseRepository});

  Future<Either<Failure, bool>> call({required String productId, String? selectedSize}) async {
    return firebaseRepository.toggleAddingToCart(productId: productId, selectedSize: selectedSize);
  }
}