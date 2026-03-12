import 'package:shopy/features/Order/data/models/order_model.dart';
import 'package:shopy/features/Order/domain/entites/order.dart';
import 'package:shopy/features/home/Data/mappers/product_mapper.dart';

class OrderMapper {
  static OrderEntity toOrderEntity({required OrderModel orderModel}) {
    return OrderEntity(
      orderId: orderModel.orderId,
      paymentIntentId: orderModel.paymentIntentId,
      paymentMethodId: orderModel.paymentMethodId,
      userId: orderModel.userId,
      customerId: orderModel.customerId,
      totalAmount: orderModel.totalAmount,
      orderStatus: orderModel.orderStatus,
      isCompleted: orderModel.isCompleted,
      currency: orderModel.currency,
      createdAt: orderModel.createdAt,
      isPaid: orderModel.isPaid,
      items: orderModel.items
          .map((eachModel) => ProductMapper.toProductEntity(eachModel))
          .toList(),
    );
  }
}
