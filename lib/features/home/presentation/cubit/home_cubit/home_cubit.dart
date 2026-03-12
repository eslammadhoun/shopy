import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/core/session/domain/usecases/set_auth_usecase.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/use_cases/get_products.dart';
import 'package:shopy/features/home/Domain/use_cases/logout_usecase.dart';
import 'package:shopy/features/home/Domain/use_cases/toggle_favourite_state.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProducts getProductsUsecase;
  final ToggleFavouriteState toggleFavouriteStateUsecase;
  final LogoutUsecase logoutUsecase;
  final SetAuthUsecase setAuthStateUsecase;

  HomeCubit({
    required this.getProductsUsecase,
    required this.toggleFavouriteStateUsecase,
    required this.logoutUsecase,
    required this.setAuthStateUsecase,
  }) : super(HomeState.initial());

  void changeSelectedPage({required int newIndex}) {
    emit(state.copyWith(selectedPage: newIndex));
  }

  void changeSelectedCategory({
    required String catecoryName,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? productSize,
  }) {
    emit(state.copyWith(selectedCategory: catecoryName));
    getProductsStream(
      catecoryName: catecoryName,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      productSize: productSize,
    );
  }

  Future<void> getProductsStream({
    required String catecoryName,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? productSize,
    String? productName,
  }) async {
    emit(state.copyWith(homeState: HomeStates.loadingProducts));
    final Either<Failure, Stream<List<Product>>> result =
        await getProductsUsecase(
          catecoryName: catecoryName,
          sortBy: sortBy,
          minPrice: minPrice,
          maxPrice: maxPrice,
          productSize: productSize,
          productName: productName,
        );
    result.fold(
      (failure) => emit(
        state.copyWith(
          homeState: HomeStates.error,
          errorMessage: failure.message,
        ),
      ),
      (success) async {
        emit(
          state.copyWith(
            homeState: HomeStates.productsLoadded,
            productsStream: success,
          ),
        );
      },
    );
  }

  void changeSelectedFilter({required String newSelectedFilter}) {
    emit(state.copyWith(selectedFilter: newSelectedFilter));
  }

  void changePriceRange({required Map<String, double> newPriceRange}) {
    emit(state.copyWith(priceRangeValues: newPriceRange));
  }

  void changeSelectedSizeFilter(String newSize) {
    emit(state.copyWith(selectedSizeFilter: newSize));
  }

  void toggleFavoriteState({required String productId}) async {
    final Either<Failure, bool> result = await toggleFavouriteStateUsecase(
      productId: productId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          homeState: HomeStates.error,
          errorMessage: failure.message,
        ),
      ),
      (favoriteState) {
        emit(
          state.copyWith(
            homeUiEvent: favoriteState
                ? HomeUiEvent.favouriteAdded
                : HomeUiEvent.favouriteRemoved,
          ),
        );
        emit(state.copyWith(homeUiEvent: HomeUiEvent.none));
      },
    );
  }

  void ressetFilter() {
    emit(
      state.withResetFilter(
        selectedFilter: null,
        selectedSizeFilter: null,
        priceRangeValues: null,
      ),
    );
    getProductsStream(catecoryName: 'All');
  }

  Future<void> logout() async {
    await logoutUsecase();
    await setAuthStateUsecase(false);
  }
}
