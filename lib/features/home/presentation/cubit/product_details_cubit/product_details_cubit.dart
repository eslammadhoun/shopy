import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';
import 'package:shopy/features/home/Domain/use_cases/add_new_rating.dart';
import 'package:shopy/features/home/Domain/use_cases/check_if_product_in_cart.dart';
import 'package:shopy/features/home/Domain/use_cases/get_product_reviews_summery.dart';
import 'package:shopy/features/home/Domain/use_cases/get_reviews.dart';
import 'package:shopy/features/home/Domain/use_cases/get_user_name.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetReviews getReviewsUsecase;
  final AddNewRating addNewRatingUsecase;
  final GetUserName getUserNameUsecase;
  final CheckIfProductInCart checkIfProductInCartUsecase;
  final GetProductReviewsSummery getProductReviewsSummeryUsecase;

  ProductDetailsCubit({
    required this.getReviewsUsecase,
    required this.addNewRatingUsecase,
    required this.getUserNameUsecase,
    required this.getProductReviewsSummeryUsecase,
    required this.checkIfProductInCartUsecase,
  }) : super(ProductDetailsState.initial());

  void changeSelectedSize({required String size}) {
    emit(state.copyWith(selectedSize: size));
  }

  void reset() {
    emit(ProductDetailsState.initial());
  }

  void getProductReviews({required String productId}) {
    emit(state.copyWith(getReviewsState: GetReviewsState.loading));

    final Either<Failure, Stream<List<Review>>> result = getReviewsUsecase(
      productId: productId,
    );
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            getReviewsState: GetReviewsState.error,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            getReviewsState: GetReviewsState.loadded,
            productReviewsStream: success,
          ),
        );
      },
    );
  }

  void setStarRate(int count) {
    emit(state.copyWith(starRate: count));
  }

  Future<void> addNewRating({
    required Review review,
    required String productId,
  }) async {
    final Either<Failure, void> result = await addNewRatingUsecase(
      review: review,
      productId: productId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          addNewRatingEvent: AddNewRatingEvent.failed,
          errorMessage: failure.message,
        ),
      ),
      (success) =>
          emit(state.copyWith(addNewRatingEvent: AddNewRatingEvent.success)),
    );
  }

  Future<void> getUserName() async {
    final Either<Failure, String> result = await getUserNameUsecase();

    result.fold(
      (failure) => emit(state),
      (success) => emit(state.copyWith(userName: success)),
    );
  }

  void getProductReviewsSummery({required String productId}) {
    emit(
      state.copyWith(
        getProductReviewsSummeryState: GetProductReviewsSummeryState.loading,
      ),
    );
    final Either<Failure, Stream<Map<String, dynamic>>> result =
        getProductReviewsSummeryUsecase(productId: productId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          getProductReviewsSummeryState: GetProductReviewsSummeryState.error,
          reviewsSummeryErrorMessage: failure.message,
        ),
      ),
      (success) {
        emit(
          state.copyWith(
            getProductReviewsSummeryState:
                GetProductReviewsSummeryState.loadded,
            productReviewsSummery: success,
          ),
        );
      },
    );
  }

  Future<void> checkIsProductInCart({required String productId}) async {
    emit(state.copyWith(
        isProductInCartState: IsProductInCartState.loading
      ));
    final Either<Failure, bool> result = await checkIfProductInCartUsecase(
      productId: productId,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isProductInCartState: IsProductInCartState.error,
        isProductInCartErrorMessage: failure.message
      )),
      (success) {
        emit(state.copyWith(
        isProductInCartState: IsProductInCartState.loadded,
        isAddedToCart: success,
      ));
      }
    );
  }
}
