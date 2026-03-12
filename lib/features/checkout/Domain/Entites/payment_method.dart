class PaymentMethod {
  final String paymentMethodId;
  final Card card;

  const PaymentMethod({required this.paymentMethodId, required this.card});
}

class Card {
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;

  const Card({
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });
}
