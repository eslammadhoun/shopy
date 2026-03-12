import 'package:flutter/material.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

class ProductSearchResult extends StatelessWidget {
  final Product product;
  const ProductSearchResult({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 48,
      height: 54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary900Color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    product.productImageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: AppLoadingIndicator(size: 40, strokeWidth: 5),
                        );
                      }
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12, height: 12),
              Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: 4),
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
                        '\$ ${product.productFinalPrice}',
                        style: AppTextStyle.b3Medium.copyWith(
                          color: AppColors.primary500Color,
                        ),
                      ),
                      product.productHaseDescont
                          ? Text(
                              '  -${product.descontRate}%',
                              style: AppTextStyle.b3SemiBold.copyWith(
                                color: AppColors.error,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: Transform.rotate(
              angle: 128,
              child: Icon(Icons.arrow_back, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
