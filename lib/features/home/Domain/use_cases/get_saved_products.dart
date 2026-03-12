import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetSavedProducts {
  final FirebaseRepository firebaseRepository;

  const GetSavedProducts({required this.firebaseRepository});

  Future<Either<Failure, Stream<List<Product>>>> call() {
    return firebaseRepository.getSavedProductsStream();
  }
}