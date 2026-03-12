import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';

abstract class OrdersFirebaseRepository {
  // Get User Orders 
  Future<Either<Failure, Stream<List<OrderProduct>>>> getOrdersStream();
}