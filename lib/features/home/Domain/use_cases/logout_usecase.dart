import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class LogoutUsecase {
  final FirebaseRepository firebaseRepository;
  const LogoutUsecase({required this.firebaseRepository});

  Future<void> call() async {
    await firebaseRepository.logOut();
  }
}