abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});
}

class CachFailure extends Failure {
  const CachFailure(super.message, {super.code});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class ApiFailure extends Failure {
  const ApiFailure(super.message, {super.code});
}

class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message, {super.code});
}

class GeolocatorFailure extends Failure {
  const GeolocatorFailure(super.message, {super.code});
}

class StripeFailure extends Failure {
  const StripeFailure(super.message, {super.code});
}
