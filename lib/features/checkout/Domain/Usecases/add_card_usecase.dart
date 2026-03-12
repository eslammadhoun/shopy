import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/repositores/stripe_repository.dart';

class AddCardUsecase {
  final StripeRepository stripeRepository;
  const AddCardUsecase({required this.stripeRepository});

  Future<Either<Failure, void>> call() {
    return stripeRepository.addNewCard();
  }
}
