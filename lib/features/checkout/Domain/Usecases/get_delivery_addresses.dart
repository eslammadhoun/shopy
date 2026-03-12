import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class GetDeliveryAddresses {
  final CheckoutFirebaseRepository checkoutFirebaseRepository;
  const GetDeliveryAddresses({required this.checkoutFirebaseRepository});

  Future<Either<Failure, Stream<List<DeliveryAddress>>>> call() {
      return checkoutFirebaseRepository.getDeliveryAddressesStream();
  }
}