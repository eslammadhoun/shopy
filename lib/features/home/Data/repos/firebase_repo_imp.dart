import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Data/data_sources/firebase_datasource.dart';
import 'package:shopy/features/home/Data/mappers/product_mapper.dart';
import 'package:shopy/features/home/Data/mappers/recent_search_mapper.dart';
import 'package:shopy/features/home/Data/mappers/review_mapper.dart';
import 'package:shopy/features/home/Data/models/product_model.dart';
import 'package:shopy/features/home/Data/models/recent_search_model.dart';
import 'package:shopy/features/home/Data/models/review_model.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/entites/recent_search.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class FirebaseRepoImp implements FirebaseRepository {
  final FirebaseDatasource firebaseDatasource;
  FirebaseRepoImp({required this.firebaseDatasource});

  @override
  Future<Either<Failure, Stream<List<Product>>>> getProducts({
    required String catecoryName,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? productSize,
    String? searchQuery,
  }) async {
    try {
      final Stream<List<ProductModel>> streamOfProductModels =
          firebaseDatasource.getProductsStream(
            catecoryName: catecoryName,
            sortBy: sortBy,
            minPrice: minPrice,
            maxPrice: maxPrice,
            productSize: productSize,
            searchQuery: searchQuery,
          );
      final Stream<List<Product>> streamOfProducts = streamOfProductModels.map(
        (listOfModels) => listOfModels
            .map(
              (eachProductModel) =>
                  ProductMapper.toProductEntity(eachProductModel),
            )
            .toList(),
      );
      return Right(streamOfProducts);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavoriteState({
    required String productId,
  }) async {
    try {
      return Right(
        await firebaseDatasource.toggleFavoriteState(productId: productId),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToRecentSearches({
    required String searchQuery,
  }) async {
    try {
      return Right(
        firebaseDatasource.addToRecentSearches(searchQuery: searchQuery),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<List<RecentSearch>>>>
  getRecentSearchesStream() async {
    try {
      final Stream<List<RecentSearchModel>> recentSearchesModels =
          await firebaseDatasource.getRecentSearchesStream();
      final Stream<List<RecentSearch>> recentSearchesStream =
          recentSearchesModels.map(
            (listOfModels) => listOfModels
                .map(
                  (eachModel) =>
                      RecentSearchMapper.toRecentSearchEntity(model: eachModel),
                )
                .toList(),
          );
      return Right(recentSearchesStream);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSearchCase({
    required String searchCaseId,
  }) async {
    try {
      final bool result = await firebaseDatasource.deleteSearchCase(
        searchCaseId: searchCaseId,
      );

      return Right(result);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistory() async {
    try {
      return Right(await firebaseDatasource.deleteAllSearchHistory());
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get The Saved Products Stream
  @override
  Future<Either<Failure, Stream<List<Product>>>>
  getSavedProductsStream() async {
    try {
      // First Try to get the list of models from the data source
      final Stream<List<ProductModel>> listOfModels = await firebaseDatasource
          .getSavedProductsStream();

      // then convert the model => Entity => return the result
      return Right(
        listOfModels.map(
          (listOfModels) => listOfModels
              .map((model) => ProductMapper.toProductEntity(model))
              .toList(),
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Either<Failure, Stream<List<Review>>> getProductReviews({
    required String productId,
  }) {
    try {
      final Stream<List<ReviewModel>> streamOfModels = firebaseDatasource
          .getProductReviewsStream(productId: productId);

      return Right(
        streamOfModels.map(
          (listOfModels) => listOfModels
              .map((model) => ReviewMapper.toEntity(model))
              .toList(),
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addNewRating({
    required Review review,
    required String productId,
  }) async {
    try {
      return Right(
        firebaseDatasource.addNewRatingOrReview(
          review: review,
          productId: productId,
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get Current User Name
  @override
  Future<Either<Failure, String>> getUserName() async {
    try {
      return Right(await firebaseDatasource.getUserName());
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get Product Reviews Summery
  @override
  Either<Failure, Stream<Map<String, dynamic>>> getProductReviewsSummery({
    required String productId,
  }) {
    try {
      return Right(
        firebaseDatasource.getProductReviewsSummery(productId: productId),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // toggle adding to cart
  @override
  Future<Either<Failure, bool>> toggleAddingToCart({
    required String productId,
    String? selectedSize,
  }) async {
    try {
      final bool result = await firebaseDatasource.toggleAddingToCart(
        productId: productId,
        selectedSize: selectedSize,
      );
      return Right(result);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get The Cart Products Stream
  @override
  Future<Either<Failure, Stream<List<Product>>>> getCartProductsStream() async {
    try {
      final Stream<List<ProductModel>> streamOfModels = firebaseDatasource
          .getCartProducts();
      return Right(
        streamOfModels.map(
          (listOfModels) => listOfModels
              .map((model) => ProductMapper.toProductEntity(model))
              .toList(),
        ),
      );
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Check If The Product In Cart
  @override
  Future<Either<Failure, bool>> checkIfProductInCart({
    required String productId,
  }) async {
    try {
      final bool isProductInCart = await firebaseDatasource
          .checkIfProductInCart(productId: productId);
      return Right(isProductInCart);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // Get product Quantity
  @override
  Future<Either<Failure, Stream<int>>> getQuantity({
    required String productId,
  }) async {
    try {
      return Right(await firebaseDatasource.getQuantity(productId: productId));
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  // increment Product Quantity
  @override
  void incrementQuantity({required String productId}) {
    return firebaseDatasource.incrementQuantity(productId: productId);
  }

  // dencrement Product Quantity
  @override
  void deincrementQuantity({required String productId}) {
    return firebaseDatasource.deincrementQuantity(productId: productId);
  }

  // User Sign Out
  @override
  Future<void> logOut() async {
    await firebaseDatasource.logOut();
  }
}
