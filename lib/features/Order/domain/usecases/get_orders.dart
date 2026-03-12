import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';
import 'package:shopy/features/Order/domain/repositories/orders_firebase_repository.dart';

class GetOrders {
  final OrdersFirebaseRepository firebaseRepository;
  const GetOrders({required this.firebaseRepository});

  Future<Either<Failure, Stream<List<OrderProduct>>>> call() async{
    return firebaseRepository.getOrdersStream();
  }
}