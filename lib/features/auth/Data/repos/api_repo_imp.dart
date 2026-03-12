import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Data/data_sources/api_auth_service.dart';
import 'package:shopy/features/auth/Domain/repos/api_repository.dart';

class ApiRepoImp implements ApiRepository {
  final ApiAuthService apiAuthService;
  const ApiRepoImp({required this.apiAuthService});

  @override
  Future<Either<Failure, void>> sendOtpCode(String email, int otpCode) async {
    try {
      return Right(await apiAuthService.sendOtpCode(email, otpCode));
    } on ApiException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
