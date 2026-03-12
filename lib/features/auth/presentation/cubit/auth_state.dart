import 'package:equatable/equatable.dart';

enum AuthStates {
  initial,
  loading,
  success,
  error,
  googleLoading,
  facebookLoading,
  sendingOtpCode,
  otpSent,
  verifingOtp,
  otpVerified,
  changeingPassword,
  passwordChanged
}

class AuthState extends Equatable {
  // auth state
  final AuthStates state;
  final String? errorMessage;

  // otp code data
  final List<String> otpDigits;
  final String otpCode;

  // password eye state
  final bool isPasswordObscured;
  final bool? isConfiermPasswordObscured;

  // fields values
  final String userName;
  final String email;
  final String password;
  final String? confirmPassword;

  // validations States
  final bool isNameValid;
  final bool isNameTouched;

  final bool isEmailValid;
  final bool isEmailTouched;

  final bool isPasswordValid;
  final bool isOtpValid;

  final bool? isConfirmPasswordValid;
  final bool? isConfirmPasswordTouched;

  // name error/success state getters
  bool get showNameError => (isNameTouched) && !isNameValid;
  bool get showNameSuccess => isNameValid && isNameTouched;

  // email error/success state getters
  bool get showEmailError => (isEmailTouched) && !isEmailValid;
  bool get showEmailSuccess => isEmailValid && isEmailTouched;

  // form state to send data to server
  bool get isSignUpFormValid => isEmailValid && isNameValid && isPasswordValid;
  bool get isLoginFormValid => isEmailValid && isPasswordValid;

  // otp complete state
  bool get isOtpCompleted => otpCode.length == 4;

  // constructor
  const AuthState({
    this.confirmPassword,
    this.isConfirmPasswordValid,
    this.isConfirmPasswordTouched,
    this.errorMessage,
    required this.state,
    required this.isPasswordObscured,
    this.isConfiermPasswordObscured,
    required this.userName,
    required this.isNameValid,
    required this.isNameTouched,
    required this.email,
    required this.isEmailValid,
    required this.isEmailTouched,
    required this.password,
    required this.isPasswordValid,
    required this.otpDigits,
    required this.otpCode,
    required this.isOtpValid,
  });

  // initial named constructor
  factory AuthState.initial() {
    return AuthState(
      state: AuthStates.initial,
      errorMessage: null,
      isPasswordObscured: true,
      isConfiermPasswordObscured: true,
      email: '',
      userName: '',
      password: '',
      isNameValid: false,
      isNameTouched: false,
      isEmailValid: false,
      isEmailTouched: false,
      isPasswordValid: false,
      isConfirmPasswordTouched: false,
      isConfirmPasswordValid: false,
      otpDigits: ['', '', '', ''],
      otpCode: '',
      isOtpValid: false,
      confirmPassword: '',
    );
  }

  // copyWith for changeing the object data
  AuthState copyWith({
    AuthStates? state,
    String? errorMessage,
    bool? isPasswordObscured,
    bool? isConfiermPasswordObscured,
    String? userName,
    bool? isNameValid,
    bool? isNameTouched,
    bool? isSubmitted,
    String? email,
    bool? isEmailValid,
    bool? isEmailTouched,
    String? password,
    bool? isPasswordValid,
    bool? isConfirmPasswordTouched,
    bool? isConfirmPasswordValid,
    bool? isPasswordTouched,
    List<String>? otpDigits,
    String? otpCode,
    bool? isOtpValid,
    String? confirmPassword,
  }) {
    return AuthState(
      otpDigits: otpDigits ?? this.otpDigits,
      otpCode: otpCode ?? this.otpCode,
      errorMessage: errorMessage ?? this.errorMessage,
      state: state ?? this.state,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfiermPasswordObscured:
          isConfiermPasswordObscured ?? this.isConfiermPasswordObscured,
      userName: userName ?? this.userName,
      isNameValid: isNameValid ?? this.isNameValid,
      isNameTouched: isNameTouched ?? this.isNameTouched,
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isEmailTouched: isEmailTouched ?? this.isEmailTouched,
      password: password ?? this.password,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isOtpValid: isOtpValid ?? this.isOtpValid,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isConfirmPasswordTouched:
          isConfirmPasswordTouched ?? this.isConfirmPasswordTouched,
      isConfirmPasswordValid:
          isConfirmPasswordValid ?? this.isConfirmPasswordValid,
    );
  }

  // Equatable implementaion
  @override
  List<Object?> get props => [
    otpDigits,
    otpCode,
    errorMessage,
    state,
    isPasswordObscured,
    isConfiermPasswordObscured,
    userName,
    isNameValid,
    isNameTouched,
    email,
    isEmailValid,
    isEmailTouched,
    password,
    isPasswordValid,
    isOtpValid,
    confirmPassword,
    isConfirmPasswordTouched,
    isConfirmPasswordValid,
  ];
}
