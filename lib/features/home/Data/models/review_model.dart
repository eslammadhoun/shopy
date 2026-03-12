import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final int rate;
  final String? description;
  final String reviewOwner;
  final Timestamp createdAt;

  const ReviewModel({
    required this.rate,
    this.description,
    required this.reviewOwner,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> map) {
    return ReviewModel(
      rate: map['review_rate'],
      description: map['review_description'],
      reviewOwner: map['review_owner'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_rate': rate,
      'review_description': description,
      'review_owner': reviewOwner,
      'createdAt': createdAt,
    };
  }
}
