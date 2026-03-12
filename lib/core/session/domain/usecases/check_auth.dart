import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/core/session/domain/repos/session_repo.dart';

class CheckAuth {
  final SessionRepo sessionRepo;
  CheckAuth({required this.sessionRepo});

  Either<Failure, bool> call() {
    return sessionRepo.checkAuth();
  }
}