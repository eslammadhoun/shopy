import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/product_details_cubit/product_details_state.dart';
import 'package:shopy/features/home/presentation/screens/reviews_page.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      if (mounted) {
        context.read<ProductDetailsCubit>().getProductReviewsSummery(
          productId: widget.product.productId,
        );
        context.read<ProductDetailsCubit>().checkIsProductInCart(
          productId: widget.product.productId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    TitleSection(title: 'Details'),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(height: 20),
                          _buildProductImageSection(context),
                          SizedBox(height: 12),
                          _buildProductInfoSection(
                            context: context,
                            listOfSizes: widget.product.productSizes,
                            productId: widget.product.productId,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildAddtoCartSection(context: context),
          ],
        ),
      ),
    );
  }

  // build product image section
  Widget _buildProductImageSection(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: MediaQuery.of(context).size.width - 22,
      decoration: BoxDecoration(
        color: AppColors.primary600Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: widget.product.productImageUrl,
              progressIndicatorBuilder: (context, url, progress) =>
                  Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 200),
              fadeOutDuration: const Duration(milliseconds: 100),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff525252).withOpacity(0.25),
                    blurRadius: 14,
                    offset: Offset(0, 11),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        context.read<HomeCubit>().toggleFavoriteState(
                          productId: widget.product.productId,
                        );
                        widget.product.isAddedToFavorite
                            ? widget.product.isAddedToFavorite = false
                            : widget.product.isAddedToFavorite = true;
                      },
                      child: widget.product.isAddedToFavorite
                          ? SvgPicture.asset(
                              'lib/assets/icons/heart-filled.svg',
                            )
                          : SvgPicture.asset('lib/assets/icons/heart.svg'),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // build product informations section
  Widget _buildProductInfoSection({
    required BuildContext context,
    required List<dynamic> listOfSizes,
    required String productId,
  }) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.productName,
              style: AppTextStyle.h3SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            SizedBox(height: 13),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewsPage(productId: productId),
                ),
              ),
              child: StreamBuilder(
                stream: state.productReviewsSummery,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: AppLoadingIndicator(size: 40, strokeWidth: 5),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No Data Found!!'));
                  } else {
                    final Map<String, dynamic> productReviewsSummery =
                        snapshot.data!;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Color(0xffFFA928)),
                        SizedBox(width: 6),
                        Text(
                          '${productReviewsSummery['product_rate'].toStringAsFixed(1)}/5',
                          style: AppTextStyle.b1Medium.copyWith(
                            color: AppColors.primary900Color,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          ' (${productReviewsSummery['product_reviews_count']} reviews)',
                          style: AppTextStyle.b1Medium.copyWith(
                            color: AppColors.primary500Color,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 13),
            Text(
              widget.product.productDescription,
              style: AppTextStyle.b1Regular.copyWith(
                color: AppColors.primary500Color,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Choose size',
              style: AppTextStyle.h4SemiBold.copyWith(
                color: AppColors.primary900Color,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemCount: listOfSizes.length,
                itemBuilder: (context, index) {
                  final size = listOfSizes[index];
                  return _buildSizeWidget(
                    size: size,
                    isSelected: size == state.selectedSize,
                    onTap: () => context
                        .read<ProductDetailsCubit>()
                        .changeSelectedSize(size: listOfSizes[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // build size Widget
  Widget _buildSizeWidget({
    required String size,
    required void Function()? onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary900Color : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary900Color
                : AppColors.primary100Color,
            width: 1.35,
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: AppTextStyle.h4Medium.copyWith(
              color: isSelected
                  ? AppColors.primary100Color
                  : AppColors.primary900Color,
            ),
          ),
        ),
      ),
    );
  }

  // build Add to cart section
  Widget _buildAddtoCartSection({required BuildContext context}) {
    return Container(
      height: 105,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.primary100Color, width: 1.35),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: AppTextStyle.b1Regular.copyWith(
                    color: AppColors.primary500Color,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '\$ ${widget.product.productFinalPrice}',
                      style: AppTextStyle.h3SemiBold,
                    ),
                    widget.product.productHaseDescont
                        ? Text(
                            ' - ${widget.product.descontRate}%',
                            style: AppTextStyle.b2Medium.copyWith(
                              color: AppColors.error,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            ),
            SizedBox(width: 30),
            Expanded(
              child: BlocListener<CartCubit, CartState>(
                listener: (BuildContext context, state) {
                  if (state.toggleAddingToCartEvent ==
                      ToggleAddingToCartEvent.productAdded) {
                    AppSnackBar.show(
                      context,
                      message: 'Product Added to Cart!',
                      type: SnackBarType.success,
                      heartFill: true,
                    );
                  } else if (state.toggleAddingToCartEvent ==
                      ToggleAddingToCartEvent.productRemoved) {
                    AppSnackBar.show(
                      context,
                      message: 'Product Removed From Cart',
                      type: SnackBarType.success,
                    );
                  }
                  context.read<ProductDetailsCubit>().checkIsProductInCart(
                    productId: widget.product.productId,
                  );
                },
                child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                  builder: (BuildContext context, state) {
                    return GestureDetector(
                      onTap: () {
                        if (state.isAddedToCart) {
                          context.read<CartCubit>().toggleAddingToCart(
                            productId: widget.product.productId,
                            selectedSize: state.selectedSize,
                          );
                        } else {
                          if (state.selectedSize == null) {
                            AppSnackBar.show(
                              context,
                              message: 'You Must Choose Size',
                            );
                          } else {
                            context.read<CartCubit>().toggleAddingToCart(
                              productId: widget.product.productId,
                              selectedSize: state.selectedSize,
                            );
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary900Color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('lib/assets/icons/bag.svg'),
                                SizedBox(width: 10),
                                Text(
                                  state.isAddedToCart
                                      ? 'Remove form cart'
                                      : 'Add to Cart',
                                  style: AppTextStyle.b1Medium.copyWith(
                                    color: AppColors.background,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
