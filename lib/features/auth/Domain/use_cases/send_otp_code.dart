import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/repos/api_repository.dart';

class SendOtpCodeUsecase {
  final ApiRepository apiRepository;
  const SendOtpCodeUsecase({required this.apiRepository});

  Future<Either<Failure, void>> call(String email)async {
    final int otpCode = _generateOtp();
    return await apiRepository.sendOtpCode(email, otpCode);
  }

    int _generateOtp() {
    return Random().nextInt(9000) + 1000; // 4 digits
  }
}