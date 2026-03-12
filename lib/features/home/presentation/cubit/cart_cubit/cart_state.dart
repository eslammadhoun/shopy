import 'package:equatable/equatable.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

enum FetchProductsState { initial, loading, loadded, error }

enum ToggleAddingToCartEvent {productAdded, productRemoved}

class CartState extends Equatable {
  final FetchProductsState fetchProductsState;
  final ToggleAddingToCartEvent? toggleAddingToCartEvent;
  final String? getProductsErrorMessage;
  final List<Product> cartProducts;
  final double subTotal;
  final double shippingFee;
  final double total;
  
  const CartState({
    required this.fetchProductsState,
    required this.getProductsErrorMessage,
    this.toggleAddingToCartEvent,
    required this.cartProducts,
    required this.subTotal,
    required this.shippingFee,
    required this.total,
  });

  factory CartState.initial() {
    return CartState(
      fetchProductsState: FetchProductsState.initial,
      getProductsErrorMessage: null,
      cartProducts: [],
      subTotal: 0,
      shippingFee: 0,
      total: 0
    );
  }

  CartState copyWith({
    FetchProductsState? fetchProductsState,
    String? getProductsErrorMessage,
    ToggleAddingToCartEvent? toggleAddingToCartEvent,
    List<Product>? cartProducts,
    double? subTotal,
    double? shippingFee,
    double? total
  }) {
    return CartState(
      fetchProductsState: fetchProductsState ?? this.fetchProductsState,
      getProductsErrorMessage:
          getProductsErrorMessage ?? this.getProductsErrorMessage,
      toggleAddingToCartEvent:
          toggleAddingToCartEvent ?? this.toggleAddingToCartEvent,
      cartProducts: cartProducts ?? this.cartProducts,
      subTotal: subTotal ?? this.subTotal,
      shippingFee:  shippingFee ?? this.shippingFee,
      total: total ?? this.total
    );
  }

  @override
  List<Object?> get props => [
    fetchProductsState,
    getProductsErrorMessage,
    toggleAddingToCartEvent,
    cartProducts,
    subTotal,
    shippingFee,
    total
  ];
}
