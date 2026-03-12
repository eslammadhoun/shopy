import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_state.dart';

class CartProductWidget extends StatefulWidget {
  final Product product;
  const CartProductWidget({super.key, required this.product});

  @override
  State<CartProductWidget> createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    return Container(
      width: MediaQuery.of(context).size.width - 48,
      height: 108,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary100Color, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 83,
              height: 79,
              decoration: BoxDecoration(
                color: AppColors.primary100Color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: CachedNetworkImage(
                imageUrl: product.productImageUrl,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) =>
                    AppLoadingIndicator(size: 40, strokeWidth: 5),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: .start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: AppTextStyle.b2SemiBold.copyWith(
                              color: AppColors.primary900Color,
                            ),
                          ),
                          Text(
                            'Size ${product.selectedSize}  ',
                            style: AppTextStyle.b3Regular.copyWith(
                              color: AppColors.primary500Color,
                            ),
                          ),
                        ],
                      ),
                      BlocConsumer<CartCubit, CartState>(
                        listener: (BuildContext context, state) {
                          if (state.toggleAddingToCartEvent ==
                              ToggleAddingToCartEvent.productRemoved) {
                            AppSnackBar.show(
                              context,
                              message: 'Product Removed From Cart',
                              type: SnackBarType.success,
                            );
                          }
                        },
                        builder: (BuildContext context, state) {
                          return GestureDetector(
                            child: SvgPicture.asset(
                              'lib/assets/icons/trash.svg',
                              width: 18,
                            ),
                            onTap: () =>
                                context.read<CartCubit>().toggleAddingToCart(
                                  productId: product.productId,
                                ),
                          );
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        '\$ ${product.productFinalPrice}',
                        style: AppTextStyle.b2SemiBold.copyWith(
                          color: AppColors.primary900Color,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _isUpdating
                                ? null
                                : () async {
                                    setState(() => _isUpdating = true);
                                    await context
                                        .read<CartCubit>()
                                        .deIncrementQuantity(
                                          productId: product.productId,
                                        );
                                    if (mounted) {
                                      setState(() => _isUpdating = false);
                                    }
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(4),
                                border: BoxBorder.all(
                                  color: AppColors.primary100Color,
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: AppColors.primary900Color,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          _isUpdating
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary900Color,
                                  ),
                                )
                              : Text(
                                  product.productQuantity.toString(),
                                  style: AppTextStyle.b3Medium.copyWith(
                                    color: AppColors.primary900Color,
                                  ),
                                ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: _isUpdating
                                ? null
                                : () async {
                                    setState(() => _isUpdating = true);
                                    await context
                                        .read<CartCubit>()
                                        .incrementQuantity(
                                          productId: product.productId,
                                        );
                                    setState(() => _isUpdating = false);
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(4),
                                border: BoxBorder.all(
                                  color: AppColors.primary100Color,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColors.primary900Color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
