import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Data/data_sources/firebase_auth_service.dart';
import 'package:shopy/features/auth/Data/mappers/user_mapper.dart';
import 'package:shopy/features/auth/Data/models/user_model.dart';
import 'package:shopy/features/auth/Domain/entites/user.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;
  const AuthRepositoryImp(this.firebaseAuthService);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserModel user = await firebaseAuthService
          .signUpWithEmailAndPassword(name, email, password);
      return Right(UserMapper.toUserEntity(user));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      return Right(
        await firebaseAuthService.loginWithEmailAndPassword(email, password),
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> loginWithGoogle() async {
    try {
      final UserCredential userCredential = await firebaseAuthService
          .signInWithGoogle();
      return Right(userCredential);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> loginWithFacebook() async {
    try {
      final UserCredential userCredential = await firebaseAuthService
          .signinWithFacebook();
      return Right(userCredential);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp({
    required String otpCode,
    required String email,
  }) async {
    try {
      return Right(
        await firebaseAuthService.verifyOtp(
          inputOtp: otpCode,
          userEmail: email,
        ),
      );
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String newPassword,
    required String userEmail
  }) async {
    try {
      return Right(
        await firebaseAuthService.changePassword(newPassword: newPassword, userEmail: userEmail)
      );
    } on AppException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
