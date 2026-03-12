import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/core/session/domain/usecases/check_auth.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final CheckAuth checkAuth;
  SplashCubit({required this.checkAuth}) : super(SplashLoading());

  Future<void> getLoginState() async {
    await Future.delayed(Duration(milliseconds: 1500));
    emit(SplashLoading());

    final Either<Failure, bool> result = checkAuth();
    result.fold((failure) => emit(SplashError(failure.message)), (isLogged) {
      emit(SplashNavigate(isLogged ? '/home' : '/onboarding'));
    });
  }
}
