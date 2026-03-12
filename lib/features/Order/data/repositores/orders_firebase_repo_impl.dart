import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/Order/data/datasources/orders_firebase_datasource.dart';
import 'package:shopy/features/Order/data/mappers/order_product_mapper.dart';
import 'package:shopy/features/Order/data/models/order_product_model.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';
import 'package:shopy/features/Order/domain/repositories/orders_firebase_repository.dart';

class OrdersFirebaseRepoImpl implements OrdersFirebaseRepository {
  final OrdersFirebaseDatasource firebaseDatasource;
  const OrdersFirebaseRepoImpl({required this.firebaseDatasource});

  // Implement Get User Orders Stream
  @override
  Future<Either<Failure, Stream<List<OrderProduct>>>> getOrdersStream() async {
    try {
      final Stream<List<OrderProductModel>> streamOfModels = await firebaseDatasource
          .getOrdersStream();

      return Right(
        streamOfModels.map(
          (listOfModels) => listOfModels
              .map(
                (eachModel) => OrderProductMapper.toEntity(eachModel),
              )
              .toList(),
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }
}
