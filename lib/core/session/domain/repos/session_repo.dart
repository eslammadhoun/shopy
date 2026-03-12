// (Session => User Auth State)
// (Session Repository Contract)

import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';

abstract class SessionRepo {
  Either<Failure, bool> checkAuth();
  Future<Either<Failure, bool>> setAuthState(bool newState);
}