import 'package:shopy/features/Order/data/mappers/order_product_mapper.dart';

class OrderProductModel {
  final String orderId;
  final String productId;
  final String productName;
  final String imageUrl;
  final String productSelectedSize;
  final num productPrice;
  final OrderStatus orderStatus;
  final bool isCompleted;

  OrderProductModel({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.productSelectedSize,
    required this.productPrice,
    required this.orderStatus,
    required this.isCompleted,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      orderId: json['orderId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      imageUrl: json['imageUrl'] as String,
      productSelectedSize: json['productSelectedSize'] as String,
      productPrice: json['productPrice'] as num,
      orderStatus: OrderStatus.values.firstWhere(
        (e) => e.name == json['orderStatus'],
      ),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'productSelectedSize': productSelectedSize,
      'productPrice': productPrice,
      'orderStatus': orderStatus.name,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'OrderProductModel(orderId: $orderId, productId: $productId, productName: $productName, imageUrl: $imageUrl, productSelectedSize: $productSelectedSize, productPrice: $productPrice, orderStatus: $orderStatus, isCompleted: $isCompleted)';
  }
}
