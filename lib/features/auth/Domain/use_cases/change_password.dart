import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';

class ChangePassword {
  final AuthRepository authRepository;
  ChangePassword({required this.authRepository});

  Future<Either<Failure, void>> call({
    required String newPassword,
    required String userEmail
  }) async {
    return authRepository.changePassword(newPassword: newPassword, userEmail: userEmail);
  }
}
