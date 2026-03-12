import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopy/features/home/Data/models/product_model.dart';

class OrderModel {
  final String orderId;
  final String paymentIntentId;
  final String paymentMethodId;
  final String userId;
  final String customerId;
  final double totalAmount;
  final String orderStatus;
  final bool isCompleted;
  final String currency;
  final Timestamp createdAt;
  final bool isPaid;
  final List<ProductModel> items;

  OrderModel({
    required this.orderId,
    required this.paymentIntentId,
    required this.paymentMethodId,
    required this.userId,
    required this.customerId,
    required this.totalAmount,
    required this.orderStatus,
    required this.isCompleted,
    required this.currency,
    required this.createdAt,
    required this.isPaid,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orederId'] ?? '',
      paymentIntentId: map['paymentIntentId'] ?? '',
      paymentMethodId: map['paymentMethodId'] ?? '',
      userId: map['userId'] ?? '',
      customerId: map['customerId'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      orderStatus: map['orederStatus'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      currency: map['currency'] ?? '',
      createdAt: map['createdAt'],
      isPaid: map['isPaid'] ?? false,
      items: (map['items'] as List<dynamic>)
          .map((eachMap) => ProductModel.fromJson(eachMap))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, paymentIntentId: $paymentIntentId, paymentMethodId: $paymentMethodId, userId: $userId, customerId: $customerId, totalAmount: $totalAmount, orderStatus: $orderStatus, isCompleted: $isCompleted, currency: $currency, createdAt: $createdAt, isPaid: $isPaid, items: $items)';
  }
}
