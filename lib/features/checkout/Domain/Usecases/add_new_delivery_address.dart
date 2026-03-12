import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class AddNewDeliveryAddress {
  final CheckoutFirebaseRepository checkoutFirebaseRepository;
  const AddNewDeliveryAddress({required this.checkoutFirebaseRepository});

  Future<Either<Failure, void>> call({
    required DeliveryAddress deliveryAddress
  }) {
    return checkoutFirebaseRepository.addNewDeliveryAddress(
      deliveryAddress: deliveryAddress
    );
  }
}
