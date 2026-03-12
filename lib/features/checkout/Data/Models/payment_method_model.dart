class PaymentMethodModel {
  final String paymentMethodId;
  final CardModel card;

  const PaymentMethodModel(this.paymentMethodId, this.card);
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      json['id'] as String,
      CardModel.fromJson(Map<String, dynamic>.from(json['card'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': paymentMethodId, 'card': card.toJson()};
  }
}

class CardModel {
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;

  const CardModel({
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      expMonth: json['exp_month'] as int,
      expYear: json['exp_year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'last4': last4,
      'exp_month': expMonth,
      'exp_year': expYear,
    };
  }
}
