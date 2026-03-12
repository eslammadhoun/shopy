import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/entites/recent_search.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';

abstract class FirebaseRepository {
  // Get Products Function Contract with the datasource
  Future<Either<Failure, Stream<List<Product>>>> getProducts({
    required String catecoryName,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? productSize,
    String? searchQuery,
  });

  // trigger favorite state for product
  Future<Either<Failure, bool>> toggleFavoriteState({
    required String productId,
  });

  // add searchQuery to database
  Future<Either<Failure, void>> addToRecentSearches({
    required String searchQuery,
  });

  // Get Recent Searches Stream
  Future<Either<Failure, Stream<List<RecentSearch>>>> getRecentSearchesStream();

  // Delete the search case from database
  Future<Either<Failure, bool>> deleteSearchCase({
    required String searchCaseId,
  });

  // Delete All The Search History
  Future<Either<Failure, void>> deleteSearchHistory();

  // Get Saved Products
  Future<Either<Failure, Stream<List<Product>>>> getSavedProductsStream();

  // Get Product Reviews Stream
  Either<Failure, Stream<List<Review>>> getProductReviews({
    required String productId,
  });

  // Add New Review
  Future<Either<Failure, void>> addNewRating({
    required Review review,
    required String productId,
  });

  // Get User Name
  Future<Either<Failure, String>> getUserName();

  // Get Product Reviews Summery
  Either<Failure, Stream<Map<String, dynamic>>> getProductReviewsSummery({
    required String productId,
  });

  // Get Cart Products
  Future<Either<Failure, Stream<List<Product>>>> getCartProductsStream();

  // Toggle adding to cart
  Future<Either<Failure, bool>> toggleAddingToCart({required String productId, String? selectedSize});

  // Check if the product in cart
  Future<Either<Failure, bool>> checkIfProductInCart({required String productId});

  // Get Product quantity
  Future<Either<Failure, Stream<int>>> getQuantity({required String productId});

  // increment Product Quantity
  void incrementQuantity({required String productId});

  // deincrement Product Quantity
  void deincrementQuantity({required String productId});

  // Sign Out
  Future<void> logOut();
}
