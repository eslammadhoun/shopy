import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/entites/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserCredential>> loginWithGoogle();
  Future<Either<Failure, UserCredential>> loginWithFacebook();
  Future<Either<Failure, bool>> verifyOtp({
    required String otpCode,
    required String email,
  });
  Future<Either<Failure, void>> changePassword({required String newPassword, required String userEmail});
}
