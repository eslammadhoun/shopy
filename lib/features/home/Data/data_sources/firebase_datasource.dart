import 'package:cloud_firestore/cloud_firestore.dart' hide FirebaseException;
import 'package:firebase_auth/firebase_auth.dart' hide FirebaseException;
import 'package:flutter/services.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/features/home/Data/mappers/product_mapper.dart';
import 'package:shopy/features/home/Data/models/product_model.dart';
import 'package:shopy/features/home/Data/models/recent_search_model.dart';
import 'package:shopy/features/home/Data/models/review_model.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';

class FirebaseDatasource {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final usersCollection = FirebaseFirestore.instance.collection('Shopy_Users');

  // recent searches collection reference
  final CollectionReference searchesCollection = FirebaseFirestore.instance
      .collection('Shopy_Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('recent_searches');
  final shopyProducts = FirebaseFirestore.instance.collection('Shopy_Products');

  Stream<List<ProductModel>> getProductsStream({
    required String catecoryName,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    String? productSize,
    String? searchQuery,
  }) {
    final bool isInSearchMode = searchQuery != null && searchQuery.isNotEmpty;
    try {
      Query productsCollectionQuery = shopyProducts;
      // search mode
      if (isInSearchMode) {
        productsCollectionQuery = productsCollectionQuery
            .orderBy('product_name_lower')
            .startAt([searchQuery])
            .endAt(['$searchQuery\uf8ff']);
      } else {
        if (catecoryName == 'All' &&
            sortBy == null &&
            minPrice == null &&
            maxPrice == null &&
            productSize == null) {
        } else if (catecoryName != 'All' &&
            sortBy == null &&
            minPrice == null &&
            maxPrice == null &&
            productSize == null) {
          productsCollectionQuery = productsCollectionQuery.where(
            'product_catecory',
            isEqualTo: catecoryName,
          );
        } else if (catecoryName == 'All' &&
            sortBy == 'Relevance' &&
            minPrice != null &&
            maxPrice != null &&
            productSize != null) {
          productsCollectionQuery = productsCollectionQuery
              .where('product_final_price', isGreaterThanOrEqualTo: minPrice)
              .where('product_final_price', isLessThanOrEqualTo: maxPrice)
              .where('product_sizes', arrayContains: productSize);
        } else if (catecoryName != 'All' &&
            sortBy == 'Relevance' &&
            minPrice != null &&
            maxPrice != null &&
            productSize != null) {
          productsCollectionQuery = productsCollectionQuery
              .where('product_catecory', isEqualTo: catecoryName)
              .where('product_final_price', isGreaterThanOrEqualTo: minPrice)
              .where('product_final_price', isLessThanOrEqualTo: maxPrice)
              .where('product_sizes', arrayContains: productSize);
        } else if (catecoryName == 'All' && sortBy != 'Relevance') {
          productsCollectionQuery = productsCollectionQuery.orderBy(
            'product_final_price',
            descending: sortBy == 'Price: High - Low',
          );
        } else if (catecoryName != 'All' && sortBy != 'Relevance') {
          productsCollectionQuery = productsCollectionQuery
              .where('product_catecory', isEqualTo: catecoryName)
              .orderBy(
                'product_final_price',
                descending: sortBy == 'Price: High - Low',
              );
        }
      }
      return productsCollectionQuery.snapshots().map(
        (eachQuerySnapshot) => eachQuerySnapshot.docs
            .map(
              (eachDoc) =>
                  ProductModel.fromJson(eachDoc.data() as Map<String, dynamic>),
            )
            .toList(),
      );
    } on PlatformException catch (e) {
      throw FirebaseCustomException(message: e.toString());
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  Future<bool> toggleFavoriteState({required String productId}) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          usersCollection
              .doc(currentUserId)
              .collection('saved_products')
              .doc(productId);
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await documentReference.get();
      if (documentSnapshot.exists) {
        // first update the products collection to by fasle for that product
        await shopyProducts.doc(productId).update({
          'is_product_added_to_favorite': false,
        });
        // then delete the product from the favorite collection
        await documentReference.delete();
        return false;
      } else {
        // if the product not exists then update the products collection then remove the product from the favourite collection
        shopyProducts.doc(productId).update({
          'is_product_added_to_favorite': true,
        });
        await usersCollection
            .doc(currentUserId)
            .collection('saved_products')
            .doc(productId)
            .set({'product_id': productId, 'createdAt': Timestamp.now()});
        return true;
      }
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // get all recent searches from firestore database
  Future<Stream<List<RecentSearchModel>>> getRecentSearchesStream() async {
    try {
      return usersCollection
          .doc(currentUserId)
          .collection('recent_searches')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) {
              final Map<String, dynamic> docData = doc.data();
              return RecentSearchModel.fromJson(docData);
            }).toList(),
          );
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // add search query to the firestore database
  Future<void> addToRecentSearches({required String searchQuery}) async {
    try {
      // first check if the search query already exist
      final QuerySnapshot querySnapshot = await searchesCollection
          .where('search_query', isEqualTo: searchQuery)
          .limit(1)
          .get();

      // if exist => update the createdAt Field
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'createdAt': Timestamp.now(),
        });
        return;
      }

      // if not exist => create the new document
      final DocumentReference docRef = searchesCollection.doc();
      //then give the document his data
      await docRef.set({
        'search_query_id': docRef.id,
        'search_query': searchQuery,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // delete search case from firestore database
  Future<bool> deleteSearchCase({required String searchCaseId}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef = usersCollection
          .doc(currentUserId)
          .collection('recent_searches')
          .doc(searchCaseId);
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef
          .get();
      if (docSnapshot.exists) {
        await docRef.delete();
        return true;
      } else {
        return true;
      }
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // delete all the search history
  Future<void> deleteAllSearchHistory() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final QuerySnapshot collectionQuery = await searchesCollection.get();
      for (var doc in collectionQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // Get the saved products Collection
  Future<Stream<List<ProductModel>>> getSavedProductsStream() async {
    try {
      final Query savedProductsQuery = usersCollection
          .doc(currentUserId)
          .collection('saved_products')
          .orderBy('createdAt', descending: true);

      return savedProductsQuery.snapshots().asyncMap((savedSnapshot) async {
        if (savedSnapshot.docs.isEmpty) {
          return <ProductModel>[];
        }

        // Get the list of ids
        final List<String> listOfIds = savedSnapshot.docs.map((doc) {
          return doc.get('product_id') as String;
        }).toList();

        // Get the products
        final QuerySnapshot<Map<String, dynamic>> productsSnapshot =
            await shopyProducts.where('product_id', whereIn: listOfIds).get();
        return productsSnapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // get Stream Of Product Reviews
  Stream<List<ReviewModel>> getProductReviewsStream({
    required String productId,
  }) {
    try {
      return shopyProducts
          .doc(productId)
          .collection('product_reviews')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((eachDoc) => ReviewModel.fromJson(eachDoc.data()))
                .toList(),
          );
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  /*
    Get The Product Rating Details As [
      {
        'product_rate': value,
        'product_ratings_count: value,
        'product_reviews_count': value,
        'product_stars_details': {
          '5_star': value,
          '4_star': value,
          '3_star': value,
          '2_star': value,
          '1_star': value
        }
      }
    ]
  */
  Stream<Map<String, dynamic>> getProductReviewsSummery({
    required String productId,
  }) {
    try {
      return shopyProducts.doc(productId).snapshots().map((snapshot) {
        final Product product = ProductMapper.toProductEntity(
          ProductModel.fromJson(snapshot.data()!),
        );
        return {
          'product_rate': product.productRate,
          'product_ratings_count': product.productRatingCount,
          'product_reviews_count': product.productReviewsCount,
          'product_stars_details': product.starsDetails,
        };
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  /*
    Add New Rating if there is no Description
    Add new Review if there is Description
   */
  Future<void> addNewRatingOrReview({
    required Review review,
    required String productId,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final productRef = shopyProducts.doc(productId);
    final newRatingRef = productRef.collection('product_ratings').doc();
    final newReviewRef = productRef.collection('product_reviews').doc();
    try {
      await firestore.runTransaction((transaction) async {
        // first read the data
        final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await transaction.get(productRef);
        if (!docSnapshot.exists) {
          throw FirebaseCustomException(message: 'Product Not Found!');
        }

        //get the data from the document => to prepare the update
        final currentStarsCount = docSnapshot.get('product_stars_count') as int;
        final currentRatingsCount =
            docSnapshot.get('product_ratings_count') as int;
        final currentReviewsCount =
            docSnapshot.get('product_reviews_count') as int;

        // then update the document
        final updatedRatingsCount = currentRatingsCount + 1;
        final updatedStarsCount = currentStarsCount + review.rate;

        // add new rating if there is now description
        if (review.description == null) {
          transaction.set(newRatingRef, {
            'rate_count': review.rate,
            'rate_owner': review.reviewOwner,
            'createdAt': review.createdAt,
          });

          transaction.update(productRef, {
            'product_stars_count': updatedStarsCount,
            'product_rate': updatedStarsCount / updatedRatingsCount,
            'product_ratings_count': updatedRatingsCount,
            'stars_details.${review.rate}_star': FieldValue.increment(1),
          });
        }
        // add new review if there is description
        else {
          final updatedReviewsCount = currentReviewsCount + 1;

          // updated the document
          transaction.set(newReviewRef, {
            'review_rate': review.rate,
            'review_owner': review.reviewOwner,
            'review_description': review.description,
            'createdAt': review.createdAt,
          });

          transaction.update(productRef, {
            'product_stars_count': updatedStarsCount,
            'product_ratings_count': updatedRatingsCount,
            'product_reviews_count': updatedReviewsCount,
            'product_rate': updatedStarsCount / updatedRatingsCount,
            'stars_details.${review.rate}_star': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // Get User Name
  Future<String> getUserName() async {
    try {
      final DocumentSnapshot userDoc = await usersCollection
          .doc(currentUserId)
          .get();
      if (!userDoc.exists) {
        throw FirebaseCustomException(message: 'User Not Found');
      }
      final Map<String, dynamic> userData =
          userDoc.data() as Map<String, dynamic>;
      return userData['user_name'];
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  /* 
    Toggle Adding to cart
     If The doc is exists in cart collection => delete it
     If Not => Add The product
  */

  Future<bool> toggleAddingToCart({
    required String productId,
    String? selectedSize,
  }) async {
    try {
      final DocumentReference productRef = usersCollection
          .doc(currentUserId)
          .collection('cart_products')
          .doc(productId);
      final DocumentSnapshot productSnapshot = await productRef.get();

      // if the product exists => delete it and return false
      if (productSnapshot.exists) {
        await shopyProducts.doc(productId).update({
          'is_product_added_to_cart': false,
        });

        await productRef.delete();
        return false;
      }
      // if the product not exists then add it
      else {
        await shopyProducts.doc(productId).update({
          'is_product_added_to_cart': true,
        });
        await productRef.set({
          'product_id': productId,
          'product_selected_size': selectedSize,
          'product_quantity': 1,
          'createdAt': Timestamp.now(),
        });
        return true;
      }
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  // Get The Cart Products Stream
  Stream<List<ProductModel>> getCartProducts() {
    try {
      // first get saved products from the database
      final Query<Map<String, dynamic>> cartProducts = usersCollection
          .doc(currentUserId)
          .collection('cart_products')
          .orderBy('createdAt', descending: true);

      return cartProducts.snapshots().asyncMap((snapshot) async {
        // check if the snapshot hase documents or not
        if (snapshot.docs.isEmpty) {
          return <ProductModel>[];
        }

        // get the cart products Data like {'product_id', 'product_selected_size', 'createdAt'}
        final List<Map<String, dynamic>> cartProductsData = snapshot.docs
            .map((doc) => doc.data())
            .toList();

        // get the list of cart products ids => to get the original product from the database
        final List<String> listOfIds = cartProductsData
            .map((map) => map['product_id'] as String)
            .toList();

        final QuerySnapshot productsSnapshot = await shopyProducts
            .where('product_id', whereIn: listOfIds)
            .get();

        final Map<String, ProductModel> productsMap = {
          for (DocumentSnapshot doc in productsSnapshot.docs)
            doc['product_id']: ProductModel.fromJson(
              doc.data() as Map<String, dynamic>,
            ),
        };

        return cartProductsData.map((item) {
          final ProductModel product = productsMap[item['product_id']]!;
          product.selectedSize = item['product_selected_size'];
          return product;
        }).toList();
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  Future<bool> checkIfProductInCart({required String productId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await usersCollection
              .doc(currentUserId)
              .collection('cart_products')
              .doc(productId)
              .get();
      return productSnapshot.exists;
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  void incrementQuantity({required String productId}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docReference =
          usersCollection
              .doc(currentUserId)
              .collection('cart_products')
              .doc(productId);
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await docReference.get();

      if (!docSnapshot.exists) {
        throw FirebaseCustomException(message: 'Product Not Found!');
      }
      await docReference.update({'product_quantity': FieldValue.increment(1)});
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  void deincrementQuantity({required String productId}) async {
    try {
      final DocumentReference<Map<String, dynamic>> docReference =
          usersCollection
              .doc(currentUserId)
              .collection('cart_products')
              .doc(productId);
      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await docReference.get();

      if (!docSnapshot.exists) {
        throw FirebaseCustomException(message: 'Product Not Found!');
      }
      await docReference.update({'product_quantity': FieldValue.increment(-1)});
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  Future<Stream<int>> getQuantity({required String productId}) async {
    try {
      final DocumentReference<Map<String, dynamic>> documentReference =
          usersCollection
              .doc(currentUserId)
              .collection('cart_products')
              .doc(productId);

      return documentReference.snapshots().map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return 0;
        }
        final Map<String, dynamic> snapshotData = snapshot.data()!;
        return snapshotData['product_quantity'];
      });
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }
}
