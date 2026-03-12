import 'package:shopy/features/Order/data/mappers/order_product_mapper.dart';

class OrderProduct {
  final String orderId;
  final String productId;
  final String productName;
  final String imageUrl;
  final String productSelectedSize;
  final num productPrice;
  final OrderStatus orderStatus;
  final bool isCompleted;

  OrderProduct({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.productSelectedSize,
    required this.productPrice,
    required this.orderStatus,
    required this.isCompleted,
  });
}
