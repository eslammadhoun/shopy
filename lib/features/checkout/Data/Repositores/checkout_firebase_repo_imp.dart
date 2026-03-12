import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Data/Data_Sources/checkout_firebase_datasource.dart';
import 'package:shopy/features/checkout/Data/Mappers/delivery_address_mapper.dart';
import 'package:shopy/features/checkout/Data/Mappers/payment_method_mapper.dart';
import 'package:shopy/features/checkout/Data/Models/delivery_address_model.dart';
import 'package:shopy/features/checkout/Data/Models/payment_method_model.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';
import 'package:shopy/features/checkout/Domain/repositores/checkout_firebase_repository.dart';

class CheckoutFirebaseRepoImp implements CheckoutFirebaseRepository {
  final CheckoutFirebaseDatasource firebaseDatasource;
  const CheckoutFirebaseRepoImp({required this.firebaseDatasource});

  // add new delivery address
  @override
  Future<Either<Failure, void>> addNewDeliveryAddress({
    required DeliveryAddress deliveryAddress,
  }) async {
    try {
      final DeliveryAddressModel deliveryAddressModel =
          DeliveryAddressMapper.toModel(entity: deliveryAddress);
      await firebaseDatasource.addNewDeliveryAddress(
        deliveryAddressModel: deliveryAddressModel,
      );
      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get Delivery addresses stream
  @override
  Future<Either<Failure, Stream<List<DeliveryAddress>>>>
  getDeliveryAddressesStream() async {
    try {
      final Stream<List<DeliveryAddressModel>> streamOfModels =
          await firebaseDatasource.getDeliveryAddressesStream();

      return Right(
        streamOfModels.map(
          (listOfModels) => listOfModels
              .map((model) => DeliveryAddressMapper.toEnitity(model))
              .toList(),
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // change the selected delivery address
  @override
  Future<Either<Failure, void>> changeSelectedDeliveryAddress({
    required DeliveryAddress deliveryAddress,
  }) async {
    try {
      final DeliveryAddressModel deliveryAddressModel =
          DeliveryAddressMapper.toModel(entity: deliveryAddress);
      return Right(
        await firebaseDatasource.changeTheSelectedDeliveryAddress(
          deliveryAddressModel: deliveryAddressModel,
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get the selected delivery address
  @override
  Future<Either<Failure, DeliveryAddress?>> getSelcetedDeliveryAddress() async {
    try {
      final DeliveryAddressModel? deliveryAddressModel =
          await firebaseDatasource.getSelcetedDeliveryAddress();
      if (deliveryAddressModel != null) {
        final DeliveryAddress deliveryAddress = DeliveryAddressMapper.toEnitity(
          deliveryAddressModel,
        );
        return Right(deliveryAddress);
      } else {
        return Right(null);
      }
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get Payment Methods
  @override
  Future<Either<Failure, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      return Right(await firebaseDatasource.getPaymentMethods());
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // change selected paymnet method
  @override
  Future<Either<Failure, void>> changeSelectedPaymentMethod({
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final PaymentMethodModel paymentMethodModel = PaymentMethodMapper.toModel(
        paymentMethod: paymentMethod,
      );
      return Right(
        await firebaseDatasource.savePaymentMethodToDataBase(
          paymentMethodModel: paymentMethodModel,
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentMethod?>> getSelectedPaymentMethod() async {
    try {
      final PaymentMethodModel? paymentMethodModel = await firebaseDatasource
          .getSelectedPaymentMethod();
      if (paymentMethodModel != null) {
        final PaymentMethod paymentMethod = PaymentMethodMapper.toEntity(
          model: paymentMethodModel,
        );
        return Right(paymentMethod);
      } else {
        return Right(null);
      }
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }
}
