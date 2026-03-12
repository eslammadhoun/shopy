import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/utils/time_ago.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/home/Domain/entites/review.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_state.dart';

class ReviewsPage extends StatefulWidget {
  final String productId;
  const ReviewsPage({super.key, required this.productId});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late TextEditingController reviewController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      context.read<ProductDetailsCubit>().getProductReviews(
        productId: widget.productId,
      );
      if (mounted) {
        await context.read<ProductDetailsCubit>().getUserName();
      }
      if (mounted) {
        context.read<ProductDetailsCubit>().getProductReviewsSummery(
          productId: widget.productId,
        );
      }
    });
    reviewController = TextEditingController();
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
             TitleSection(title: 'Reviews'),
              SizedBox(height: 20),
              _buildProductRatingSummary(context),
              Expanded(child: _buildListOfReviews(context: context)),
            ],
          ),
        ),
      ),
    );
  }

  // build product rating summary
  Widget _buildProductRatingSummary(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (BuildContext context, state) {
        return StreamBuilder(
          stream: state.productReviewsSummery,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: AppLoadingIndicator(size: 40, strokeWidth: 5),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Data Found, Try Again Later'));
            } else {
              final Map<String, dynamic> data = snapshot.data!;
              final Map<String, dynamic> starsDetails =
                  data['product_stars_details'];

              return Column(
                children: [
                  Row(
                    children: [
                      Text(
                        double.parse(
                          data['product_rate'].toString(),
                        ).toStringAsFixed(1),
                        style: AppTextStyle.h1SemiBold.copyWith(
                          color: AppColors.primary900Color,
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                color: index + 1 > data['product_rate']
                                    ? AppColors.primary100Color
                                    : Color(0xffFFA928),
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${data['product_ratings_count']} Ratings',
                            style: AppTextStyle.b1Regular.copyWith(
                              color: AppColors.primary500Color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ...List.generate(5, (index) {
                    final totalRatings = data['product_ratings_count'] as int;
                    final eachStarRateCount =
                        starsDetails['${index + 1}_star'] as int;

                    return Column(
                      children: [
                        _buildEachRating(
                          context: context,
                          starsCount: index + 1,
                          value: totalRatings == 0
                              ? 0.0
                              : eachStarRateCount / totalRatings,
                        ),
                        SizedBox(height: 12),
                      ],
                    );
                  }).reversed,
                  SizedBox(height: 24),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(color: AppColors.primary100Color),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }
          },
        );
      },
    );
  }

  // build Each Rating
  Widget _buildEachRating({
    required BuildContext context,
    required int starsCount,
    required double value,
  }) {
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            Icons.star,
            color: index < starsCount
                ? Color(0xffFFA928)
                : AppColors.primary100Color,
            size: 22,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.primary100Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: constraints.maxWidth * (value),
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.primary900Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // build list of reviews
  Widget _buildListOfReviews({required BuildContext context}) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (BuildContext context, state) {
        if (state.getReviewsState == GetReviewsState.initial) {
          return AppLoadingIndicator(size: 60, strokeWidth: 8);
        } else if (state.getReviewsState == GetReviewsState.loading) {
          return AppLoadingIndicator(size: 60, strokeWidth: 8);
        } else if (state.getReviewsState == GetReviewsState.error) {
          return Center(child: Text(state.errorMessage!));
        } else {
          return StreamBuilder(
            stream: state.productReviewsStream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AppLoadingIndicator(size: 60, strokeWidth: 8);
              } else if (snapshot.hasError) {
                return Center(
                  child: NoResultWidget(
                    icon: 'cancel',
                    title: snapshot.error.toString(),
                    subTitle: 'Please Try Again Later',
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NoResultWidget(
                        icon: 'heart2',
                        title: 'No Recent Reviews Yet',
                        subTitle: 'Your Opinion Matters To Us!',
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _buildNewReviewPop(context: context),
                      child: Text(
                        'Add New Review',
                        style: AppTextStyle.b1Medium.copyWith(
                          color: AppColors.primary900Color,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                final List<Review> listOfReviews = snapshot.data!;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${listOfReviews.length} Review(s)',
                          style: AppTextStyle.b1SemiBold,
                        ),
                        GestureDetector(
                          onTap: () => _buildNewReviewPop(context: context),
                          child: Text(
                            'Add New Review',
                            style: AppTextStyle.b3Medium.copyWith(
                              color: AppColors.primary500Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: listOfReviews.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              color: AppColors.primary100Color,
                            ),
                          ),
                        ),
                        itemBuilder: (context, index) {
                          final Review review = listOfReviews[index];
                          return _buildReview(review: review);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }

  // build Review
  Widget _buildReview({required Review review}) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              color: index < review.rate
                  ? Color(0xffFFA928)
                  : AppColors.primary100Color,
              size: 22,
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          review.description!,
          style: AppTextStyle.b2Regular.copyWith(
            color: AppColors.primary500Color,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              review.reviewOwner,
              style: AppTextStyle.b3SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            Text(
              ' •  ${TimeAgo.timeAgoFromTimestamp(review.createdAt)} ',
              style: AppTextStyle.b3SemiBold.copyWith(
                color: AppColors.primary500Color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // build add new review pupup
  void _buildNewReviewPop({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Container(
                      width: 64,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary100Color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Leave a Review', style: AppTextStyle.h4SemiBold),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('lib/assets/icons/cancel.svg'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(color: AppColors.primary100Color),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How was your order?',
                    style: AppTextStyle.h4SemiBold.copyWith(
                      color: AppColors.primary900Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please give your rating and also your review.',
                    style: AppTextStyle.b2Regular.copyWith(
                      color: AppColors.primary500Color,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
                    listener: (BuildContext context, state) {
                      if (state.addNewRatingEvent ==
                          AddNewRatingEvent.success) {
                        AppSnackBar.show(
                          context,
                          message: 'New Review Added',
                          type: SnackBarType.success,
                        );
                      } else if (state.addNewRatingEvent ==
                          AddNewRatingEvent.failed) {
                        AppSnackBar.show(
                          context,
                          message:
                              'Faild to Add New Review: ${state.errorMessage}',
                          type: SnackBarType.error,
                        );
                      }
                    },
                    builder: (BuildContext context, state) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: .center,
                            children: List.generate(
                              5,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: GestureDetector(
                                  onTap: () => context
                                      .read<ProductDetailsCubit>()
                                      .setStarRate(index + 1),
                                  child: Icon(
                                    Icons.star,
                                    size: 40,
                                    color: index + 1 <= state.starRate
                                        ? Color(0xffFFA928)
                                        : AppColors.primary100Color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: reviewController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary100Color,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors.primary100Color,
                                  width: 1,
                                ),
                              ),
                              hintText: 'Write your review...',
                              hintStyle: AppTextStyle.b1Regular.copyWith(
                                color: AppColors.primary400Color,
                              ),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          GlobalButton(
                            backgroundColor: AppColors.primary900Color,
                            border: BoxBorder.all(
                              color: AppColors.primary900Color,
                            ),
                            onTap: () async {
                              final Review newReview = Review(
                                rate: state.starRate,
                                description: reviewController.text.isEmpty
                                    ? null
                                    : reviewController.text,
                                reviewOwner: state.userName ?? 'Undefind Name',
                                createdAt: Timestamp.now(),
                              );
                              await context
                                  .read<ProductDetailsCubit>()
                                  .addNewRating(
                                    review: newReview,
                                    productId: widget.productId,
                                  );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              reviewController.clear();
                            },

                            child: Center(
                              child: Text(
                                'Submit',
                                style: AppTextStyle.b1Medium.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
