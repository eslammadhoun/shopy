import 'package:dartz/dartz.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Data/Data_Sources/stripe_datasource.dart';
import 'package:shopy/features/checkout/Domain/repositores/stripe_repository.dart';

class StripeRepositoryImp implements StripeRepository {
  final StripeDatasource stripeDatasource;
  const StripeRepositoryImp({required this.stripeDatasource});

  @override
  Future<Either<Failure, void>> addNewCard() async {
    try {
      return Right(await stripeDatasource.addNewCard());
    } on AppException catch (e) {
      return Left(StripeFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> createPaymentIntent({
    required int amount,
    required String paymentMethodId,
  }) async {
    try {
      return Right(
        await stripeDatasource.createPaymentIntent(
          amount: amount,
          paymentMethodId: paymentMethodId,
        ),
      );
    } on AppException catch (e) {
      return Left(StripeFailure(e.message, code: e.code));
    }
  }
}
