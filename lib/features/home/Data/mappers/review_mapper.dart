import 'package:shopy/features/home/Data/models/review_model.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';

class ReviewMapper {
  // From Review Model Class => Entity
  static Review toEntity(ReviewModel model) {
    return Review(
      rate: model.rate,
      description: model.description,
      reviewOwner: model.reviewOwner,
      createdAt: model.createdAt,
    );
  }

  // From Entity To Model
  static ReviewModel toModel(Review entity) {
    return ReviewModel(
      rate: entity.rate,
      description: entity.description,
      reviewOwner: entity.reviewOwner,
      createdAt: entity.createdAt,
    );
  }
}
