import 'package:shopy/features/home/Data/models/product_model.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

class ProductMapper {
  // From ProductModel => ProductEntity
  static Product toProductEntity(ProductModel model) {
    return Product(
      productId: model.productId,
      productName: model.productName,
      productDescription: model.productDescription,
      productPrice: model.productPrice,
      productReviewsCount: model.productReviewsCount,
      productRate: model.productRate,
      productHaseDescont: model.productHaseDescont,
      descontRate: model.descontRate,
      productImageUrl: model.productImageUrl,
      isAddedToFavorite: model.isAddedToFavorite,
      productSizes: model.productSizes,
      productFinalPrice: model.productFinalPrice,
      productCatecory: model.productCatecory,
      createdAt: model.createdAt,
      isAddedToCart: model.isAddedToCart,
      productRatingCount: model.productRatingCount,
      starsDetails: model.starsDetails,
      productQuantity: model.productQuantity,
      selectedSize: model.selectedSize
    );
  }

  static ProductModel toProductModel(Product productEntity) {
    return ProductModel(
      productId: productEntity.productId,
      productName: productEntity.productName,
      productDescription: productEntity.productDescription,
      productPrice: productEntity.productPrice,
      productReviewsCount: productEntity.productReviewsCount,
      productRate: productEntity.productRate,
      productHaseDescont: productEntity.productHaseDescont,
      descontRate: productEntity.descontRate,
      productImageUrl: productEntity.productImageUrl,
      isAddedToFavorite: productEntity.isAddedToFavorite,
      productSizes: productEntity.productSizes,
      productFinalPrice: productEntity.productFinalPrice,
      productRatingCount: productEntity.productRatingCount,
      productCatecory: productEntity.productCatecory,
      createdAt: productEntity.createdAt,
      isAddedToCart: productEntity.isAddedToCart,
      starsDetails: productEntity.starsDetails,
      productQuantity: productEntity.productQuantity,
      selectedSize: productEntity.selectedSize
    );
  }
}
