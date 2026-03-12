import 'package:equatable/equatable.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

enum GetOrdersStreamState { initial, loading, error, success }

class OrdersState extends Equatable {
  // my orders page
  final int selectedOrdersType;
  final GetOrdersStreamState getOrdersStreamState;
  final List<OrderProduct> listOfOrders;
  final String? getOrdersStreamError;
  final List<Product> ordersProducts;

  const OrdersState({
    required this.selectedOrdersType,
    required this.listOfOrders,
    required this.getOrdersStreamState,
    this.getOrdersStreamError,
    required this.ordersProducts
  });

  factory OrdersState.initial() {
    return OrdersState(
      selectedOrdersType: 0,
      listOfOrders: [],
      getOrdersStreamState: GetOrdersStreamState.initial,
      getOrdersStreamError: null,
      ordersProducts: []
    );
  }

  OrdersState copyWith({
    int? selectedOrdersType,
    List<OrderProduct>? listOfOrders,
    GetOrdersStreamState? getOrdersStreamState,
    String? getOrdersStreamError,
    List<Product>? ordersProducts
  }) {
    return OrdersState(
      selectedOrdersType: selectedOrdersType ?? this.selectedOrdersType,
      listOfOrders: listOfOrders ?? this.listOfOrders,
      getOrdersStreamState: getOrdersStreamState ?? this.getOrdersStreamState,
      getOrdersStreamError: getOrdersStreamError ?? this.getOrdersStreamError,
      ordersProducts: ordersProducts ?? this.ordersProducts
    );
  }

  @override
  List<Object?> get props => [
    selectedOrdersType,
    listOfOrders,
    getOrdersStreamState,
    getOrdersStreamError,
    ordersProducts
  ];
}
