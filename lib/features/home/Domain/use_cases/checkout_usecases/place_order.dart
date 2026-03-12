import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/repositores/stripe_repository.dart';

class PlaceOrder {
  final StripeRepository stripeRepository;
  const PlaceOrder({required this.stripeRepository});

  Future<Either<Failure, void>> call({
    required int amount,
    required String paymentMethodId,
  }) async {
    return stripeRepository.createPaymentIntent(
      paymentMethodId: paymentMethodId,
      amount: amount,
    );
  }
}
