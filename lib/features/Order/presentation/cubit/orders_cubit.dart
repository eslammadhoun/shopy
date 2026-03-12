import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';
import 'package:shopy/features/Order/domain/usecases/get_orders.dart';
import 'package:shopy/features/Order/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders getOrdersUsecase;
  OrdersCubit({required this.getOrdersUsecase}) : super(OrdersState.initial());
  StreamSubscription? _ordersStream;

  void changeOrdersType(int selectedOrdersType) {
    emit(state.copyWith(selectedOrdersType: selectedOrdersType));
  }

  Future<void> getOrdersStream() async {
    _ordersStream?.cancel();
    emit(state.copyWith(getOrdersStreamState: GetOrdersStreamState.loading));

    final Either<Failure, Stream<List<OrderProduct>>> result =
        await getOrdersUsecase();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getOrdersStreamState: GetOrdersStreamState.error,
            getOrdersStreamError: failure.message,
          ),
        );
        emit(OrdersState.initial());
      },
      (success) {
        success.listen((listOfOrders) {
          emit(
            state.copyWith(
              getOrdersStreamState: GetOrdersStreamState.success,
              listOfOrders: listOfOrders,
              ordersProducts: []
            ),
          );
        });
      },
    );
  }

  @override
  Future<void> close() async {
    _ordersStream?.cancel();
    return super.close();
  }
}
