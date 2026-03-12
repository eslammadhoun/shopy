import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class GetSelectedPaymentMethod {
  final CheckoutFirebaseRepository checkoutFirebaseRepository;
  const GetSelectedPaymentMethod({required this.checkoutFirebaseRepository});

  Future<Either<Failure, PaymentMethod?>> call() async {
    return await checkoutFirebaseRepository.getSelectedPaymentMethod();
  }
}