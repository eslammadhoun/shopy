import 'package:shopy/features/checkout/Data/Models/payment_method_model.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';

class PaymentMethodMapper {
  static PaymentMethod toEntity({required PaymentMethodModel model}) {
    return PaymentMethod(
      paymentMethodId: model.paymentMethodId,
      card: toCardEntity(cardModel: model.card),
    );
  }

  static Card toCardEntity({required CardModel cardModel}) {
    return Card(
      brand: cardModel.brand,
      last4: cardModel.last4,
      expMonth: cardModel.expMonth,
      expYear: cardModel.expYear,
    );
  }

  static PaymentMethodModel toModel({required PaymentMethod paymentMethod}) {
    return PaymentMethodModel(
      paymentMethod.paymentMethodId,
      toCardModel(card: paymentMethod.card),
    );
  }

  static CardModel toCardModel({required Card card}) {
    return CardModel(
      brand: card.brand,
      last4: card.last4,
      expMonth: card.expMonth,
      expYear: card.expYear,
    );
  }
}
