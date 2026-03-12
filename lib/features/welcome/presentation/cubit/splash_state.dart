part of 'splash_cubit.dart';

sealed class SplashState {}

class SplashLoading extends SplashState {}
class SplashError extends SplashState {
  final String errorMessage;
  SplashError(this.errorMessage);
  
}
class SplashNavigate extends SplashState {
  String route;
  SplashNavigate(this.route);
}