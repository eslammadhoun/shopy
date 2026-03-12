import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/Order/domain/entites/order_product.dart';
import 'package:shopy/features/Order/presentation/cubit/orders_cubit.dart';
import 'package:shopy/features/Order/presentation/cubit/orders_state.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<OrdersCubit>().getOrdersStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              TitleSection(title: 'My Orders'),
              const SizedBox(height: 24.0),
              _buildOrdersType(context: context),
              const SizedBox(height: 20),
              Expanded(child: _buildListOfOrders()),
            ],
          ),
        ),
      ),
    );
  }

  // build orders type [ongoing or completed]
  Widget _buildOrdersType({required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.primary100Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) => Row(
          children: List.generate(
            2,
            (index) => InkWell(
              onTap: () => context.read<OrdersCubit>().changeOrdersType(index),
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  decoration: BoxDecoration(
                    color: state.selectedOrdersType == index
                        ? AppColors.background
                        : AppColors.primary100Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      index == 0 ? 'Ongoing' : 'Completed',
                      style: AppTextStyle.b2Medium.copyWith(
                        color: state.selectedOrdersType == index
                            ? AppColors.primary900Color
                            : AppColors.primary400Color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // build list of orders
  Widget _buildListOfOrders() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (BuildContext context, state) {
        if (state.getOrdersStreamState == GetOrdersStreamState.loading) {
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        } else if (state.getOrdersStreamState == GetOrdersStreamState.error) {
          return Center(child: Text('Error: ${state.getOrdersStreamError}'));
        } else if (state.listOfOrders.isEmpty) {
          return NoResultWidget(
            icon: 'orderBox',
            title: 'No Ongoing Orders!',
            subTitle: 'You don’t have any ongoing orders at this time.',
          );
        } else {
          final List<OrderProduct> listOfOrdersProducts = state.listOfOrders
              .where(
                (order) => order.isCompleted == (state.selectedOrdersType == 1),
              )
              .toList();
          return ListView.separated(
            itemCount: listOfOrdersProducts.length,
            itemBuilder: (context, index) => _buildOrderProductWidget(
              context: context,
              product: listOfOrdersProducts[index],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 15),
          );
        }
      },
    );
  }

  // Order Widget
  Widget _buildOrderProductWidget({
    required BuildContext context,
    required OrderProduct product,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 48,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: AppColors.primary100Color),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary900Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
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
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.productName,
                      style: AppTextStyle.b2SemiBold.copyWith(
                        color: AppColors.primary900Color,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary100Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          product.orderStatus.name,
                          style: AppTextStyle.b3SemiBold.copyWith(
                            color: AppColors.primary900Color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Size ${product.productSelectedSize}',
                  style: AppTextStyle.b3Regular.copyWith(
                    color: AppColors.primary500Color,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$ ${product.productPrice}',
                      style: AppTextStyle.b2SemiBold.copyWith(
                        color: AppColors.primary900Color,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary900Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Track Order',
                        style: AppTextStyle.b3SemiBold.copyWith(
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
