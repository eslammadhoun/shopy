import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';

abstract class ApiRepository {
  Future<Either<Failure, void>> sendOtpCode(String email, int otpCode);
}