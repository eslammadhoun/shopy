import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class DeincrementQuantity {
  final FirebaseRepository firebaseRepository;
  const DeincrementQuantity({required this.firebaseRepository});

  void call({required String productId}) {
    return firebaseRepository.deincrementQuantity(productId: productId);
  }
}