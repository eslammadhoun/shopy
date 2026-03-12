import 'package:dartz/dartz.dart' show Either;
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetCartProducts {
  final FirebaseRepository firebaseRepository;
  const GetCartProducts({required this.firebaseRepository});

  Future<Either<Failure, Stream<List<Product>>>> call() {
    return firebaseRepository.getCartProductsStream();
  }
}