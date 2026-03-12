import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepository;
  LoginUsecase({required this.authRepository});

  Future<Either<Failure, void>> call({required String email, required String password}) {
    return authRepository.login(email: email, password: password);
  }
}