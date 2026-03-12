import 'package:cloud_firestore/cloud_firestore.dart' hide FirebaseException;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide FirebaseException;
import 'package:flutter_stripe/flutter_stripe.dart' hide PaymentMethod;
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/features/checkout/Data/Mappers/payment_method_mapper.dart';
import 'package:shopy/features/checkout/Data/Models/delivery_address_model.dart';
import 'package:shopy/features/checkout/Data/Models/payment_method_model.dart';
import 'package:shopy/features/checkout/Domain/Entites/payment_method.dart';

class CheckoutFirebaseDatasource {
  // Firebase Functions Instance
  final FirebaseFunctions functions;
  // the current Signed User id
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  // users collection
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('Shopy_Users');

  CheckoutFirebaseDatasource({required this.functions});
  // products collection
  final CollectionReference<Map<String, dynamic>> shopyProducts =
      FirebaseFirestore.instance.collection('Shopy_Products');
  // delivery address collection
  final CollectionReference<Map<String, dynamic>> deliveryAddressesCollection =
      FirebaseFirestore.instance
          .collection('Shopy_Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('delivery_addresses');

  // Add new Delivery Address to the database
  Future<void> addNewDeliveryAddress({
    required DeliveryAddressModel deliveryAddressModel,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query =
          await deliveryAddressesCollection.where('is_marked_as_default').get();
      if (query.docs.isNotEmpty) {
        if (deliveryAddressModel.isDefault == true) {
          throw Exception('You Can Add Only One Location As Default');
        }
      }
      final DocumentReference<Map<String, dynamic>> addressDocument =
          deliveryAddressesCollection.doc();
      final String documentId = addressDocument.id;
      deliveryAddressModel.id = documentId;
      await addressDocument.set(deliveryAddressModel.toJson());
    } on AppException catch (e) {
      throw FirebaseCustomException(message: e.message);
    }
  }

  // Get list Of Delivery Addresses from the database
  Future<Stream<List<DeliveryAddressModel>>>
  getDeliveryAddressesStream() async {
    try {
      final Query<Map<String, dynamic>> query = deliveryAddressesCollection
          .orderBy('createdAt', descending: true);
      return query.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => DeliveryAddressModel.fromJson(doc.data()))
            .toList(),
      );
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // Get the selected delivery address
  Future<DeliveryAddressModel?> getSelcetedDeliveryAddress() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> currentUser =
          await usersCollection.doc(currentUserId).get();
      final Map<String, dynamic> userData = currentUser.data()!;
      if (userData.containsKey('selected_delivery_address')) {
        return DeliveryAddressModel.fromJson(
          userData['selected_delivery_address'],
        );
      } else {
        return null;
      }
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // change the selected delivery address
  Future<void> changeTheSelectedDeliveryAddress({
    required DeliveryAddressModel deliveryAddressModel,
  }) async {
    try {
      await usersCollection.doc(currentUserId).update({
        'selected_delivery_address': deliveryAddressModel.toJson(),
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // Get List of Payment Methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await usersCollection.doc(currentUserId).get();
      if (!documentSnapshot.exists) {
        throw FirebaseCustomException(message: 'User Not Logged In');
      }
      final Map<String, dynamic> docData = documentSnapshot.data()!;

      final String? stripeCustomerId = docData['stripeCustomerId'];
      if (stripeCustomerId == null) {
        return [];
      } else {
        final HttpsCallableResult<dynamic> result = await functions
            .httpsCallable('getCustomerCards')
            .call({'customerId': stripeCustomerId});
        final List<dynamic> rawData = List<dynamic>.from(result.data);
        final List<PaymentMethodModel> listOfModels = rawData
            .map(
              (eachMap) => PaymentMethodModel.fromJson(
                Map<String, dynamic>.from(eachMap as Map),
              ),
            )
            .toList();
        final List<PaymentMethod> listOfPaymentMethods = listOfModels
            .map((eachModel) => PaymentMethodMapper.toEntity(model: eachModel))
            .toList();
        return listOfPaymentMethods;
      }
    } on StripeException catch (e) {
      throw StripeCustomException(message: e.error.localizedMessage ?? 'Stripe Error');
    } on StripeConfigException catch (e) {
      final message = e.message;
      throw StripeCustomException(message: message);
    } on FirebaseFunctionsException catch (e) {
      final message = e.message;

      throw StripeCustomException(message: message ?? 'Firebase Functions Exception');
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // save the desired payment method on firebase firestore
  Future<void> savePaymentMethodToDataBase({
    required PaymentMethodModel paymentMethodModel,
  }) async {
    try {
      await usersCollection.doc(currentUserId).update({
        'selected_payment_method': paymentMethodModel.toJson(),
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // Get the selected payment method
  Future<PaymentMethodModel?> getSelectedPaymentMethod() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> currentUser =
          await usersCollection.doc(currentUserId).get();
      final Map<String, dynamic> userData = currentUser.data()!;
      if (userData.containsKey('selected_payment_method')) {
        return PaymentMethodModel.fromJson(userData['selected_payment_method']);
      } else {
        return null;
      }
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }
}
