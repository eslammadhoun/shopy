import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';

class VerifyOtp {
  final AuthRepository authRepository;
  VerifyOtp({required this.authRepository});

  Future<Either<Failure, bool>> call({
    required String otpCode,
    required String userEmail,
  }) async {
    return await authRepository.verifyOtp(otpCode: otpCode, email: userEmail);
  }
}
