import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopy/core/errors/exceptions.dart';

class StripeDatasource {
  final FirebaseFunctions functions;
  StripeDatasource({required this.functions});

  Future<void> addNewCard() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw StripeCustomException(message: 'User Not signed In');
      }
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: const PaymentMethodData(),
        ),
      );

      if (paymentMethod.id.isEmpty) {
        throw StripeCustomException(message: 'Error Creating Payment Method');
      }

      await functions.httpsCallable('addCard').call({
        'paymentMethodId': paymentMethod.id,
      });
    } on FirebaseFunctionsException catch (e, s) {
      throw StripeCustomException(
        message: e.message ?? 'Payment failed',
        devMessage: e.details?.toString(),
        code: e.code,
        stackTrace: s,
      );
    } catch (e) {
      throw StripeCustomException(
        message: e.toString() + e.runtimeType.toString(),
      );
    }
  }

  Future<void> createPaymentIntent({
    required int amount,
    required String paymentMethodId,
  }) async {
    try {
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final QuerySnapshot cartProductsQuery = await FirebaseFirestore.instance
          .collection('Shopy_Users')
          .doc(currentUserId)
          .collection('cart_products')
          .get();

      final List<Map<String, dynamic>> listOfCartProducts = cartProductsQuery
          .docs
          .map((eachDoc) {
            final Map<String, dynamic> docData =
                eachDoc.data() as Map<String, dynamic>;
            return {
              "product_id": docData['product_id'],
              "product_quantity": docData['product_quantity'],
              "product_selected_size": docData['product_selected_size'],
            };
          })
          .toList();

      final functionCallable = functions.httpsCallable('createPaymentIntent');

      await functionCallable.call({
        'amount': amount,
        'paymentMethodId': paymentMethodId,
        'items': listOfCartProducts,
      });
    } on FirebaseFunctionsException catch (e, s) {
      throw StripeCustomException(
        message: e.message ?? 'Payment failed',
        devMessage: e.details?.toString(),
        code: e.code,
        stackTrace: s,
      );
    } catch (e) {
      throw StripeCustomException(message: "Unexpected error occurred");
    }
  }
}
