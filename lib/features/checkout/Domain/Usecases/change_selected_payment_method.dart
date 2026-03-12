import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class ChangeSelectedPaymentMethod {
  final CheckoutFirebaseRepository checkoutFirebaseRepository;
  const ChangeSelectedPaymentMethod({required this.checkoutFirebaseRepository});

  Future<Either<Failure, void>> call({required PaymentMethod paymentMethod}) {
    return checkoutFirebaseRepository.changeSelectedPaymentMethod(paymentMethod: paymentMethod);
  }
}