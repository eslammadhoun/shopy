import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/core/session/domain/repos/session_repo.dart';

class SetAuthUsecase {
  final SessionRepo sessionRepo;
  SetAuthUsecase({required this.sessionRepo});

  Future<Either<Failure, bool>> call(bool state) async {
    return await sessionRepo.setAuthState(state);
  }
}