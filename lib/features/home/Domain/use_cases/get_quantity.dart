import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetQuantity {
  final FirebaseRepository firebaseRepository;
  const GetQuantity({required this.firebaseRepository});

  Future<Either<Failure,Stream<int>>> call({required String productId}) {
    return firebaseRepository.getQuantity(productId: productId);
  }
}