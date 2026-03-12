import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class IncrementQuantity {
  final FirebaseRepository firebaseRepository;
  const IncrementQuantity({required this.firebaseRepository});

  Future<void> call({required String productId}) async {
    return firebaseRepository.incrementQuantity(productId: productId);
  }
}