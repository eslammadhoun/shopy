import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';

abstract class CheckoutFirebaseRepository {
  Future<Either<Failure, void>> addNewDeliveryAddress({
    required DeliveryAddress deliveryAddress
  });

  // Get Delivery Addresses Stream
  Future<Either<Failure, Stream<List<DeliveryAddress>>>> getDeliveryAddressesStream();

  // Get the selected delivery address
  Future<Either<Failure, DeliveryAddress?>> getSelcetedDeliveryAddress();

  // change the selected delivery address
  Future<Either<Failure, void>> changeSelectedDeliveryAddress({required DeliveryAddress deliveryAddress});

  // Get Payment Methods
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods();

  // change selected payment method
  Future<Either<Failure, void>> changeSelectedPaymentMethod({required PaymentMethod paymentMethod});

  // Get Selected Payment Method
  Future<Either<Failure, PaymentMethod?>> getSelectedPaymentMethod();
}
