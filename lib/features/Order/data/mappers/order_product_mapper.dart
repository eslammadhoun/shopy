import 'package:shopy/features/Order/data/models/order_product_model.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';

enum OrderStatus { pending, packing, picked, inTransit, delivered }

class OrderProductMapper {
  static OrderProduct toEntity(OrderProductModel orderProductModel) {
    return OrderProduct(
      orderId: orderProductModel.orderId,
      productId: orderProductModel.productId,
      productName: orderProductModel.productName,
      imageUrl: orderProductModel.imageUrl,
      productSelectedSize: orderProductModel.productSelectedSize,
      productPrice: orderProductModel.productPrice,
      orderStatus: orderProductModel.orderStatus,
      isCompleted: orderProductModel.isCompleted,
    );
  }

  static OrderProductModel toModel(OrderProduct orderProductEntity) {
    return OrderProductModel(
      orderId: orderProductEntity.orderId,
      productId: orderProductEntity.productId,
      productName: orderProductEntity.productName,
      imageUrl: orderProductEntity.imageUrl,
      productSelectedSize: orderProductEntity.productSelectedSize,
      productPrice: orderProductEntity.productPrice,
      orderStatus: orderProductEntity.orderStatus,
      isCompleted: orderProductEntity.isCompleted,
    );
  }
}
