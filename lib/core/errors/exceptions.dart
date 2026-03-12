abstract class AppException implements Exception {
  final String message;
  final String? devMessage;
  final String? code;
  final StackTrace? stackTrace;

  const AppException(
    this.message, {
    this.devMessage,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException(message: $message, code: $code, devMessage: $devMessage)';
  }
}

class CacheException extends AppException {
  const CacheException({
    String message = 'Cache error occurred',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'CACHE_ERROR',
         stackTrace: stackTrace,
       );
}

class AuthException extends AppException {
  const AuthException({
    String message = 'Authentication failed',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'AUTH_ERROR',
         stackTrace: stackTrace,
       );
}

class NetworkException extends AppException {
  const NetworkException({
    String message = 'Network error, please try again',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'NETWORK_ERROR',
         stackTrace: stackTrace,
       );
}

class ApiException extends AppException {
  const ApiException({
    String message = 'Server error occurred',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'API_ERROR',
         stackTrace: stackTrace,
       );
}

class StripeCustomException extends AppException {
  const StripeCustomException({
    String message = 'Payment failed',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'STRIPE_ERROR',
         stackTrace: stackTrace,
       );
}

class GeolocatorCustomException extends AppException {
  const GeolocatorCustomException({
    String message = 'Location failed',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'GEOLOCATOR_ERROR',
         stackTrace: stackTrace,
       );
}

class FirebaseCustomException extends AppException {
  const FirebaseCustomException({
    String message = 'Firebase Error',
    String? devMessage,
    String? code,
    StackTrace? stackTrace,
  }) : super(
         message,
         devMessage: devMessage,
         code: code ?? 'FIREBASE_ERROR',
         stackTrace: stackTrace,
       );
}
