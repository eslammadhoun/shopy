import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/core/session/domain/usecases/check_auth.dart';
import 'package:shopy/core/session/domain/usecases/set_auth_usecase.dart';
import 'package:shopy/core/utils/validators.dart';
import 'package:shopy/features/auth/Domain/entites/user.dart';
import 'package:shopy/features/auth/Domain/use_cases/change_password.dart';
import 'package:shopy/features/auth/Domain/use_cases/login_usecase.dart';
import 'package:shopy/features/auth/Domain/use_cases/login_with_facebook.dart';
import 'package:shopy/features/auth/Domain/use_cases/login_with_google_usecase.dart';
import 'package:shopy/features/auth/Domain/use_cases/send_otp_code.dart';
import 'package:shopy/features/auth/Domain/use_cases/signup_usecase.dart';
import 'package:shopy/features/auth/Domain/use_cases/verify_otp.dart';
import 'package:shopy/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignupUsecase signupUsecase;
  final LoginUsecase loginUsecase;
  final SetAuthUsecase setAuthState;
  final CheckAuth checkAuth;
  final LoginWithGoogle loginWithGoogleUsecase;
  final LoginWithFacebook loginWithFacebookUsecase;
  final SendOtpCodeUsecase sendOtpCodeUsecase;
  final VerifyOtp verifyOtpuseCase;
  final ChangePassword changePassworduseCase;

  AuthCubit({
    required this.signupUsecase,
    required this.checkAuth,
    required this.setAuthState,
    required this.loginUsecase,
    required this.loginWithGoogleUsecase,
    required this.loginWithFacebookUsecase,
    required this.sendOtpCodeUsecase,
    required this.verifyOtpuseCase,
    required this.changePassworduseCase,
  }) : super(AuthState.initial());

  void onUserNameChanged(String name) {
    emit(
      state.copyWith(
        userName: name,
        isNameTouched: true,
        isNameValid: Validators.isNameValid(name),
      ),
    );
  }

  void onEmailChanged(String email) {
    emit(
      state.copyWith(
        email: email,
        isEmailTouched: true,
        isEmailValid: Validators.isEmailValid(email),
      ),
    );
  }

  void onPasswordChanged(String password) {
    emit(
      state.copyWith(
        password: password,
        isPasswordTouched: true,
        isPasswordValid: Validators.isPasswordValid(password),
      ),
    );
  }

  void onConfirmPasswordChanged(String confirmPassword) {
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        isConfirmPasswordTouched: true,
        isConfirmPasswordValid: Validators.isConfirmPasswordValid(
          state.password,
          confirmPassword,
        ),
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(
        isConfiermPasswordObscured: !state.isConfiermPasswordObscured!,
      ),
    );
  }

  Future<void> signUp() async {
    emit(state.copyWith(state: AuthStates.loading));

    final Either<Failure, UserEntity> result = await signupUsecase(
      name: state.userName,
      email: state.email,
      password: state.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(state: AuthStates.error, errorMessage: failure.message),
      ),
      (user) async {
        await setAuthState(true);
        emit(state.copyWith(state: AuthStates.success));
      },
    );
  }

  Future<void> login() async {
    emit(state.copyWith(state: AuthStates.loading));

    final Either<Failure, void> result = await loginUsecase(
      email: state.email,
      password: state.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(state: AuthStates.error, errorMessage: failure.message),
      ),
      (success) async {
        await setAuthState(true);
        emit(state.copyWith(state: AuthStates.success));
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(state: AuthStates.googleLoading));

    final Either<Failure, UserCredential> result =
        await loginWithGoogleUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(state: AuthStates.error, errorMessage: failure.message),
      ),
      (success) async {
        await setAuthState(true);
        emit(state.copyWith(state: AuthStates.success));
      },
    );
  }

  Future<void> loginWithFacebook() async {
    emit(state.copyWith(state: AuthStates.facebookLoading));

    final Either<Failure, UserCredential> result =
        await loginWithFacebookUsecase();
    result.fold(
      (failure) => emit(
        state.copyWith(state: AuthStates.error, errorMessage: failure.message),
      ),
      (success) async {
        await setAuthState(true);
        emit(state.copyWith(state: AuthStates.success));
      },
    );
  }

  Future<void> sendOtpCode(String email) async {
    emit(state.copyWith(state: AuthStates.sendingOtpCode));

    final Either<Failure, void> result = await sendOtpCodeUsecase(email);
    result.fold((failure) {
      emit(
        state.copyWith(state: AuthStates.error, errorMessage: failure.message),
      );
    }, (success) => emit(state.copyWith(state: AuthStates.otpSent)));
  }

  void onOtpChanged({required int index, required String value}) {
    List<String> updatedList = List<String>.from(state.otpDigits);
    updatedList[index] = value;

    emit(state.copyWith(otpDigits: updatedList, otpCode: updatedList.join()));
  }

  Future<void> verifyOtp({
    required String otpCode,
    required String userEmail,
  }) async {
    emit(state.copyWith(state: AuthStates.verifingOtp));

    final Either<Failure, bool> result = await verifyOtpuseCase(
      otpCode: otpCode,
      userEmail: userEmail,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            state: AuthStates.error,
            errorMessage: failure.message,
          ),
        );
      },
      (success) => emit(
        state.copyWith(state: AuthStates.otpVerified, isOtpValid: success),
      ),
    );
  }

  Future<void> changePassword({
    required String newPassword,
    required String userEmail
  }) async {
    emit(state.copyWith(state: AuthStates.changeingPassword));
    final Either<Failure, void> result = await changePassworduseCase(
      newPassword: newPassword,
      userEmail: userEmail
    );
    result.fold(
      (failure) => emit(
        state.copyWith(state: AuthStates.error, errorMessage: failure.message),
      ),
      (success) => emit(state.copyWith(state: AuthStates.passwordChanged)),
    );
  }

  Future<void> logout() async {
    setAuthState(false);
  }
}
