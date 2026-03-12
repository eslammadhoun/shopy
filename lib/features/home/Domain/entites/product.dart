import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Product extends Equatable {
  final String productId;
  final String productName;
  final String productDescription;
  final num productPrice;
  final int productReviewsCount;
  final num productRate;
  final bool productHaseDescont;
  final num descontRate;
  final String productImageUrl;
  bool isAddedToFavorite;
  final List productSizes;
  final num productFinalPrice;
  final String productCatecory;
  final Timestamp createdAt;
  final bool isAddedToCart;
  final num productRatingCount;
  final Map<String, dynamic> starsDetails;
  final num productQuantity;
  final String? selectedSize;

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productReviewsCount,
    required this.productRate,
    required this.productHaseDescont,
    required this.descontRate,
    required this.productImageUrl,
    required this.isAddedToFavorite,
    required this.productSizes,
    required this.productFinalPrice,
    required this.productCatecory,
    required this.createdAt,
    required this.isAddedToCart,
    required this.productRatingCount,
    required this.starsDetails,
    required this.productQuantity,
    this.selectedSize
  });

  Product copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    num? productPrice,
    int? productReviewsCount,
    num? productRate,
    bool? productHaseDescont,
    num? descontRate,
    String? productImageUrl,
    bool? isAddedToFavorite,
    List? productSizes,
    num? productFinalPrice,
    String? productCatecory,
    Timestamp? createdAt,
    bool? isAddedToCart,
    num? productRatingCount,
    Map<String, dynamic>? starsDetails,
    num? productQuantity,
    String? selectedSize,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      productPrice: productPrice ?? this.productPrice,
      productReviewsCount: productReviewsCount ?? this.productReviewsCount,
      productRate: productRate ?? this.productRate,
      productHaseDescont: productHaseDescont ?? this.productHaseDescont,
      descontRate: descontRate ?? this.descontRate,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      isAddedToFavorite: isAddedToFavorite ?? this.isAddedToFavorite,
      productSizes: productSizes ?? this.productSizes,
      productFinalPrice: productFinalPrice ?? this.productFinalPrice,
      productCatecory: productCatecory ?? this.productCatecory,
      createdAt: createdAt ?? this.createdAt,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
      productRatingCount: productRatingCount ?? this.productRatingCount,
      starsDetails: starsDetails ?? this.starsDetails,
      productQuantity: productQuantity ?? this.productQuantity,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productDescription,
    productPrice,
    productReviewsCount,
    productRate,
    productHaseDescont,
    descontRate,
    productImageUrl,
    isAddedToFavorite,
    productSizes,
    productFinalPrice,
    productRatingCount,
    isAddedToCart,
    productCatecory,
    createdAt,
    starsDetails,
    productQuantity,
    selectedSize
  ];
}
