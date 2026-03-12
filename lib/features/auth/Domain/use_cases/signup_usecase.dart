import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/auth/Domain/entites/user.dart';
import 'package:shopy/features/auth/Domain/repos/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repo;
  SignupUsecase(this.repo);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return repo.signUp(name: name, email: email, password: password);
  }
}
