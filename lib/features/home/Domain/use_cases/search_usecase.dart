import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/repos/firebase_repository.dart';

class SearchUsecase {
  final FirebaseRepository firebaseRepository;
  const SearchUsecase({required this.firebaseRepository});

  Future<Either<Failure, Stream<List<Product>>>> call({required String searchQuery}) {
    return firebaseRepository.getProducts(catecoryName: 'All', searchQuery: searchQuery);
  }
}