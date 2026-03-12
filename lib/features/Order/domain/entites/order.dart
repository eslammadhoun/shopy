import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

class OrderEntity {
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
  final List<Product> items;

  OrderEntity({
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

  @override
  String toString() {
    return 'OrderEntity('
        'orderId: $orderId, '
        'paymentIntentId: $paymentIntentId, '
        'paymentMethodId: $paymentMethodId, '
        'userId: $userId, '
        'customerId: $customerId, '
        'totalAmount: $totalAmount, '
        'orderStatus: $orderStatus, '
        'isCompleted: $isCompleted, '
        'currency: $currency, '
        'createdAt: $createdAt, '
        'isPaid: $isPaid, '
        'items: $items'
        ')';
  }
}
