import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class GetProducts {
  final FirebaseRepository firebaseRepository;
  GetProducts({required this.firebaseRepository});

  Future<Either<Failure, Stream<List<Product>>>> call({
    required String catecoryName,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? productSize,
    String? productName
  }) async {
    return await firebaseRepository.getProducts(
      catecoryName: catecoryName,
      sortBy: sortBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      productSize: productSize,
      searchQuery: productName
    );
  }
}
