import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final int rate;
  final String? description;
  final String reviewOwner;
  final Timestamp createdAt;

  Review({
    required this.rate,
    this.description,
    required this.reviewOwner,
    required this.createdAt,
  });
}
