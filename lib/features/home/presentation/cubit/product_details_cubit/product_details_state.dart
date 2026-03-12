import 'package:equatable/equatable.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';

enum GetReviewsState { initial, loading, loadded, error }

enum AddNewRatingEvent { failed, success }

enum GetProductReviewsSummeryState { initial, loading, loadded, error }

enum IsProductInCartState { initial, loading, loadded, error }

class ProductDetailsState extends Equatable {
  final GetReviewsState getReviewsState;
  final String? selectedSize;
  final String? errorMessage;
  final int starRate;
  final AddNewRatingEvent? addNewRatingEvent;
  final String? userName;
  final GetProductReviewsSummeryState? getProductReviewsSummeryState;
  final String? reviewsSummeryErrorMessage;
  final Stream<List<Review>> productReviewsStream;
  final Stream<Map<String, dynamic>> productReviewsSummery;
  final bool isAddedToCart;
  final IsProductInCartState? isProductInCartState;
  final String? isProductInCartErrorMessage;

  const ProductDetailsState({
    required this.selectedSize,
    required this.getReviewsState,
    required this.errorMessage,
    required this.starRate,
    required this.addNewRatingEvent,
    required this.userName,
    required this.getProductReviewsSummeryState,
    required this.reviewsSummeryErrorMessage,
    required this.productReviewsStream,
    required this.productReviewsSummery,
    required this.isAddedToCart,
    required this.isProductInCartState,
    required this.isProductInCartErrorMessage
  });

  factory ProductDetailsState.initial() {
    return ProductDetailsState(
      selectedSize: null,
      getReviewsState: GetReviewsState.initial,
      errorMessage: null,
      starRate: 5,
      addNewRatingEvent: null,
      userName: null,
      getProductReviewsSummeryState: GetProductReviewsSummeryState.initial,
      reviewsSummeryErrorMessage: null,
      productReviewsStream: Stream.empty(),
      productReviewsSummery: Stream.empty(),
      isAddedToCart: false,
      isProductInCartState: IsProductInCartState.initial,
      isProductInCartErrorMessage: null
    );
  }

  ProductDetailsState copyWith({
    String? selectedSize,
    GetReviewsState? getReviewsState,
    String? errorMessage,
    int? starRate,
    AddNewRatingEvent? addNewRatingEvent,
    String? userName,
    GetProductReviewsSummeryState? getProductReviewsSummeryState,
    String? reviewsSummeryErrorMessage,
    Stream<List<Review>>? productReviewsStream,
    Stream<Map<String, dynamic>>? productReviewsSummery,
    bool? isAddedToCart,
    IsProductInCartState? isProductInCartState,
    String? isProductInCartErrorMessage
  }) {
    return ProductDetailsState(
      selectedSize: selectedSize ?? this.selectedSize,
      getReviewsState: getReviewsState ?? this.getReviewsState,
      errorMessage: errorMessage ?? this.errorMessage,
      starRate: starRate ?? this.starRate,
      addNewRatingEvent: addNewRatingEvent ?? this.addNewRatingEvent,
      userName: userName ?? this.userName,
      getProductReviewsSummeryState:
          getProductReviewsSummeryState ?? this.getProductReviewsSummeryState,
      reviewsSummeryErrorMessage:
          reviewsSummeryErrorMessage ?? this.reviewsSummeryErrorMessage,
      productReviewsStream: productReviewsStream ?? this.productReviewsStream,
      productReviewsSummery:
          productReviewsSummery ?? this.productReviewsSummery,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      isProductInCartState: isProductInCartState ?? this.isProductInCartState,
      isProductInCartErrorMessage: isProductInCartErrorMessage ?? this.isProductInCartErrorMessage
    );
  }

  @override
  List<Object?> get props => [
    selectedSize,
    getReviewsState,
    errorMessage,
    starRate,
    addNewRatingEvent,
    userName,
    getProductReviewsSummeryState,
    reviewsSummeryErrorMessage,
    productReviewsStream,
    productReviewsSummery,
    isAddedToCart,
    isProductInCartState,
    isProductInCartErrorMessage
  ];
}
