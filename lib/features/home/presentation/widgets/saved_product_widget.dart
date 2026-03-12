import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';

class SavedProductWidget extends StatelessWidget {
  final Product product;
  const SavedProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 122,
                width: MediaQuery.of(context).size.width - 69 / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: CachedNetworkImage(
                    alignment: Alignment.topCenter,
                    imageUrl: product.productImageUrl,
                    progressIndicatorBuilder: (context, url, progress) =>
                        AppLoadingIndicator(size: 40, strokeWidth: 5),
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
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Color(0xff525252).withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 8)
                      )
                    ]
                  ),
                  child: Center(
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) => GestureDetector(
                      onTap: () => context.read<HomeCubit>().toggleFavoriteState(productId: product.productId),
                      child: SvgPicture.asset('lib/assets/icons/heart-filled.svg'),
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
          Text(
            '\$ ${product.productFinalPrice}',
            style: AppTextStyle.b3Medium.copyWith(
              color: AppColors.primary500Color,
            ),
          ),
        ],
      ),
    );
  }
}
