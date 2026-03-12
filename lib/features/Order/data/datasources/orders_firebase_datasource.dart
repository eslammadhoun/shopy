import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/features/Order/data/mappers/order_product_mapper.dart';
import 'package:shopy/features/Order/data/models/order_product_model.dart';
import 'package:shopy/features/home/Data/models/product_model.dart';

class OrdersFirebaseDatasource {
  // current signed user Id
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // Users Collection
  final CollectionReference<Map<String, dynamic>> usersCollection =
      FirebaseFirestore.instance.collection('Shopy_Users');

  // Get UserOrders
  Future<Stream<List<OrderProductModel>>> getOrdersStream() async {
    try {
      final Query<Map<String, dynamic>> ordersQuery = usersCollection
          .doc(currentUserId)
          .collection('Orders')
          .orderBy('createdAt', descending: true);

      final CollectionReference<Map<String, dynamic>> orderProductsQuery =
          FirebaseFirestore.instance.collection('Shopy_Products');

      return ordersQuery.snapshots().asyncMap((snapshot) async {
        final List<OrderProductModel> allOrderProducts = [];

        for (final orderDoc in snapshot.docs) {
          final Map<String, dynamic> orderData = orderDoc.data();

          final List<dynamic> listOfOrderItems = orderData['items'];

          final List<Map<String, String>> listOfCartProductsData =
              listOfOrderItems.map((eachProduct) {
                final String id = eachProduct['product_id'] as String;
                final String size =
                    eachProduct['product_selected_size'] as String;
                return {'id': id, 'size': size};
              }).toList();

          final List<OrderProductModel> listOfordersProducts =
              await Future.wait(
                listOfCartProductsData.map((cartProductData) async {
                  final productDoc = await orderProductsQuery
                      .doc(cartProductData['id'])
                      .get();
                  final ProductModel productModel = ProductModel.fromJson(
                    productDoc.data()!,
                  );
                  final String productSelectedSize = cartProductData['size']!;
                  final OrderStatus orderStatus = OrderStatus.values.firstWhere(
                    (status) => status.name == orderData['orderStatus'],
                  );
                  final OrderProductModel orderProductModel = OrderProductModel(
                    orderId: orderData['orderId'],
                    productId: productModel.productId,
                    productName: productModel.productName,
                    imageUrl: productModel.productImageUrl,
                    productSelectedSize: productSelectedSize,
                    productPrice: productModel.productFinalPrice,
                    orderStatus: orderStatus,
                    isCompleted: orderData['isCompleted'],
                  );

                  return orderProductModel;
                }).toList(),
              );

          allOrderProducts.addAll(listOfordersProducts);
        }

        return allOrderProducts;
      });
    } on AppException catch (e) {
      throw FirebaseCustomException(message: e.toString());
    } catch (e) {
      print(e.toString());
      throw FirebaseCustomException(message: e.toString());
    }
  }
}
