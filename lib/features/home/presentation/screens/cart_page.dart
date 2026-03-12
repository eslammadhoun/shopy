import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/cart_cubit/cart_state.dart';
import 'package:shopy/features/home/presentation/widgets/cart_product_widget.dart';
import 'package:shopy/core/widgets/price_details.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TitleSection(title: 'My Cart'),
              SizedBox(height: 20),
              Expanded(child: _buildListOfCartProducts(context: context)),
            ],
          ),
        ),
      ),
    );
  }

  // build list of cart products
  Widget _buildListOfCartProducts({required BuildContext context}) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (BuildContext context, state) {
        if (state.fetchProductsState == FetchProductsState.loading) {
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        } else if (state.fetchProductsState == FetchProductsState.error) {
          return Center(child: Text('Error: ${state.getProductsErrorMessage}'));
        } else if (state.cartProducts.isEmpty) {
          return NoResultWidget(
            icon: 'cart2',
            title: 'Your Cart Is Empty!',
            subTitle: 'When you add products, they’ll appear here.',
          );
        } else {
          final List<Product> listOfProducts = state.cartProducts;
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.42,
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        CartProductWidget(product: listOfProducts[index]),
                    separatorBuilder: (context, index) => SizedBox(height: 14),
                    itemCount: listOfProducts.length,
                  ),
                ),
                SizedBox(height: 24),
                PriceDetails(subTotal: state.subTotal, shoppingFee: state.shippingFee, total: state.total),
                Expanded(child: Container()),
                GlobalButton(
                  backgroundColor: AppColors.primary900Color,
                  border: BoxBorder.all(color: AppColors.primary900Color),
                  onTap: () => Navigator.of(context).pushNamed('/checkout'),
                  child: Text(
                    'Go To Checkout',
                    style: AppTextStyle.b1Medium.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
