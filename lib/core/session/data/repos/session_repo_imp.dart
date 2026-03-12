import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/core/session/data/data_sources/login_shared_state.dart';
import 'package:shopy/core/session/domain/repos/session_repo.dart';

class SessionRepoImp implements SessionRepo {
  final LoginSharedState loginSharedState;
  SessionRepoImp({required this.loginSharedState});

  @override
  Either<Failure, bool> checkAuth() {
    try {
      return Right(loginSharedState.isLoggedIn);
    } on AppException catch (e) {
      return Left(CachFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> setAuthState(bool newState) async {
    try {
      final bool result = await loginSharedState.setAuthState(newState);
      return Right(result);
    } on AppException catch(e) {
      return Left(CachFailure(e.toString()));
    }
  }
}