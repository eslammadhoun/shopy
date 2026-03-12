import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class GetSelectedDeliveryAddress {
  final CheckoutFirebaseRepository checkoutFirebaseRepository;
  const GetSelectedDeliveryAddress({required this.checkoutFirebaseRepository});

  Future<Either<Failure, DeliveryAddress?>> call() {
    return checkoutFirebaseRepository.getSelcetedDeliveryAddress();
  }
}