import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class GetPaymentMethods {
  final CheckoutFirebaseRepository checkoutFirebaseRepository;
  const GetPaymentMethods({required this.checkoutFirebaseRepository});

  Future<Either<Failure, List<PaymentMethod>>> call() {
    return checkoutFirebaseRepository.getPaymentMethods();
  }
}