import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class ToggleFavouriteState {
  final FirebaseRepository firebaseRepository;
  const ToggleFavouriteState({required this.firebaseRepository});

  Future<Either<Failure, bool>> call({required String productId}) async {
    return firebaseRepository.toggleFavoriteState(productId: productId);
  }
}
