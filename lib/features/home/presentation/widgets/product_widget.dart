import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final void Function()? onTap;
  const ProductWidget({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: (MediaQuery.of(context).size.width / 2) - 68,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Stack(
            children: [
              Container(
                width: (MediaQuery.of(context).size.width - 68) / 2,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.productImageUrl,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                          child: AppLoadingIndicator(size: 40, strokeWidth: 5),
                        ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 200),
                    fadeOutDuration: const Duration(milliseconds: 100),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    width: 34,
                    height: 34,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Color(0xff525252).withOpacity(0.25),
                          blurRadius: 10,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        product.isAddedToFavorite
                            ? 'lib/assets/icons/heart-filled.svg'
                            : 'lib/assets/icons/heart.svg',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            product.productName,
            style: AppTextStyle.b1SemiBold.copyWith(
              color: AppColors.primary900Color,
            ),
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Text(
                '\$ ${product.productHaseDescont ? (product.productFinalPrice) : product.productPrice}',
                style: AppTextStyle.b3Medium.copyWith(
                  color: AppColors.primary500Color,
                ),
              ),
              product.productHaseDescont
                  ? Text(
                      '  - ${product.descontRate} %',
                      style: AppTextStyle.b3Medium.copyWith(
                        color: AppColors.error,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
