import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';

abstract class StripeRepository {
  // create payment method
  Future<Either<Failure, void>> addNewCard();

  // Pay Using Strip
  Future<Either<Failure, void>> createPaymentIntent({required String paymentMethodId, required int amount});
}
