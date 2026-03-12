import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class ProductModel extends Equatable {
  final String productId;
  final String productName;
  final String productDescription;
  final num productPrice;
  final num productFinalPrice;
  final int productReviewsCount;
  final num productRatingCount;
  final num productRate;
  final bool productHaseDescont;
  final num descontRate;
  final String productImageUrl;
  final bool isAddedToFavorite;
  final bool isAddedToCart;
  final List productSizes;
  final String productCatecory;
  Timestamp createdAt;
  final Map<String, dynamic> starsDetails;
  final num productQuantity;
  String? selectedSize;

  ProductModel({
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
    required this.productRatingCount,
    required this.productCatecory,
    required this.createdAt,
    required this.isAddedToCart,
    required this.starsDetails,
    required this.productQuantity,
    this.selectedSize,
  });

  // Deserialization (From Map => Dart Object)
  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['product_id'],
      productName: map['product_name'] ?? 'Product Name',
      productDescription: map['product_description'] ?? 'Product Description',
      productPrice: map['product_price'] ?? 0,
      productReviewsCount: map['product_reviews_count'] ?? 0,
      productRate: map['product_rate'] ?? 0,
      productHaseDescont: map['product_hase_descont'] ?? false,
      descontRate: map['descont_rate'] ?? 0,
      productImageUrl: map['product_image_url'] ?? '',
      isAddedToFavorite: map['is_product_added_to_favorite'] ?? false,
      productSizes: map['product_sizes'] ?? [],
      productFinalPrice: map['product_final_price'] ?? 0.0,
      productRatingCount: map['product_ratings_count'] ?? 0.0,
      productCatecory: map['product_catecory'] ?? '',
      isAddedToCart: map['is_product_added_to_cart'] ?? false,
      createdAt: map['createdAt'] ?? Timestamp.now(),
      starsDetails: map['stars_details'] ?? {},
      productQuantity: map['product_quantity'] ?? 0.0,
      selectedSize: map['selected_size'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      'product_price': productPrice,
      'product_reviews_count': productReviewsCount,
      'product_rate': productRate,
      'product_hase_descont': productHaseDescont,
      'descont_rate': descontRate,
      'product_image_url': productImageUrl,
      'is_product_added_to_favorite': isAddedToFavorite,
      'product_sizes': productSizes,
      'product_final_price': productFinalPrice,
      'stars_details': starsDetails,
    };
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
    isAddedToCart,
    productCatecory,
    createdAt,
    productRatingCount,
    starsDetails,
    productQuantity,
    selectedSize,
  ];
}
