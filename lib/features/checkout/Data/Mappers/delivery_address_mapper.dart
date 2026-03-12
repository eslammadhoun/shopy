import 'package:shopy/features/checkout/Data/Models/delivery_address_model.dart';
import 'package:shopy/features/checkout/Domain/Entites/delivery_address.dart';

class DeliveryAddressMapper {
  static DeliveryAddress toEnitity(DeliveryAddressModel model) {
    return DeliveryAddress(
      id: model.id,
      lat: model.lat,
      long: model.long,
      nickname: model.nickname,
      fullAddress: model.fullAddress,
      isDefault: model.isDefault,
      createdAt: model.createdAt,
    );
  }

  static DeliveryAddressModel toModel({required DeliveryAddress entity}) {
    return DeliveryAddressModel(
      id: entity.id,
      lat: entity.lat,
      long: entity.long,
      nickname: entity.nickname,
      fullAddress: entity.fullAddress,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
    );
  }
}
