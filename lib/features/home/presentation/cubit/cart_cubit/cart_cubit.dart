import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/use_cases/deincrement_quantity.dart';
import 'package:shopy/features/home/Domain/use_cases/get_cart_products.dart';
import 'package:shopy/features/home/Domain/use_cases/get_quantity.dart';
import 'package:shopy/features/home/Domain/use_cases/increment_quantity.dart';
import 'package:shopy/features/home/Domain/use_cases/toggle_adding_to_cart.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartProducts getCartProductsUsecase;
  final ToggleAddingToCart toggleAddingToCartUsecase;
  final IncrementQuantity incrementQuantityUsecase;
  final DeincrementQuantity deincrementQuantityUsecase;
  final GetQuantity getProductQuantityUsecase;

  StreamSubscription<List<Product>>? _sub;
  final Map<String, StreamSubscription<int>> _productQuantityStream = {};

  CartCubit({
    required this.getCartProductsUsecase,
    required this.toggleAddingToCartUsecase,
    required this.incrementQuantityUsecase,
    required this.deincrementQuantityUsecase,
    required this.getProductQuantityUsecase,
  }) : super(CartState.initial());

  // Toggle Adding to Cart Collection
  Future<void> toggleAddingToCart({
    required String productId,
    String? selectedSize,
  }) async {
    final Either<Failure, bool> result = await toggleAddingToCartUsecase(
      productId: productId,
      selectedSize: selectedSize,
    );

    result.fold(
      (failure) => emit(state),
      (success) => emit(
        state.copyWith(
          toggleAddingToCartEvent: success
              ? ToggleAddingToCartEvent.productAdded
              : ToggleAddingToCartEvent.productRemoved,
        ),
      ),
    );
  }

  // Get The Cart Products
  Future<void> getCartProducts() async {
    _sub?.cancel();
    emit(state.copyWith(fetchProductsState: FetchProductsState.loading));

    final Either<Failure, Stream<List<Product>>> result =
        await getCartProductsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          fetchProductsState: FetchProductsState.error,
          getProductsErrorMessage: failure.message,
        ),
      ),
      (success) => _sub = success.listen((products) {
        emit(
          state.copyWith(
            fetchProductsState: FetchProductsState.loadded,
            cartProducts: products,
          ),
        );
        for (var product in products) {
          getQuantity(productId: product.productId);
        }
      }),
    );
  }

  // Get Product Quantity Stream
  Future<void> getQuantity({required String productId}) async {
    _productQuantityStream[productId]?.cancel();

    final Either<Failure, Stream<int>> result = await getProductQuantityUsecase(
      productId: productId,
    );

    result.fold((failure) => emit(state), (quantityStream) {
      _productQuantityStream[productId] = quantityStream.listen((quantity) {
        if (isClosed) return;
        if (quantity == 0) {
          final updatedProducts = state.cartProducts
              .where((p) => p.productId != productId)
              .toList();
          emit(state.copyWith(cartProducts: updatedProducts));
        } else {
          final updatedProducts = state.cartProducts.map((product) {
            if (product.productId == productId) {
              return product.copyWith(productQuantity: quantity);
            }
            return product;
          }).toList();
          emit(state.copyWith(cartProducts: updatedProducts));
          double subTotal = 0;
          double shoppingFee = 0;
          double total = 0;
          for (Product product in updatedProducts) {
            subTotal += product.productFinalPrice * product.productQuantity;
            shoppingFee += product.productQuantity * 5.0;
            total = subTotal + shoppingFee;
          }
          emit(state.copyWith(subTotal: subTotal, shippingFee: shoppingFee, total: total));
        }
      });
    });
  }

  // increment Quantity
  Future<void> incrementQuantity({required String productId}) async {
    await incrementQuantityUsecase(productId: productId);
  }

  // deincrement Quantity
  Future<void> deIncrementQuantity({required String productId}) async {
    final Product product = state.cartProducts.firstWhere(
      (product) => product.productId == productId,
    );
    if (product.productQuantity == 1) {
      await toggleAddingToCart(productId: productId);
      return;
    }
    return deincrementQuantityUsecase(productId: productId);
  }

  @override
  Future<void> close() {
    for (StreamSubscription<int> sub in _productQuantityStream.values) {
      sub.cancel();
    }
    _sub?.cancel();
    return super.close();
  }
}
