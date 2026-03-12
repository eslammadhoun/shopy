import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';

class LoginWithGoogle {
  final AuthRepository authRepository;
  LoginWithGoogle({required this.authRepository});

  Future<Either<Failure, UserCredential>> call() async {
    return await authRepository.loginWithGoogle();
  }
}