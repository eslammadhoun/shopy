import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/title_section.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/presentation/cubit/saved_cubit/saved_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/saved_cubit/saved_state.dart';
import 'package:shopy/features/home/presentation/screens/product_details.dart';
import 'package:shopy/features/home/presentation/widgets/saved_product_widget.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<SavedCubit>().getSavedProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TitleSection(title: 'Saved Items'),
              SizedBox(height: 24),
              Container(height: 1, color: AppColors.primary100Color),
              SizedBox(height: 12),
              Expanded(child: _buildProductsList()),
            ],
          ),
        ),
      ),
    );
  }

  // build saved products list
  Widget _buildProductsList() {
    return BlocBuilder<SavedCubit, SavedState>(
      builder: (BuildContext context, state) {
        if (state.savedPageState == SavedPageState.loading) {
          return Center(child: AppLoadingIndicator(size: 40, strokeWidth: 5));
        } else if (state.savedPageState == SavedPageState.success) {
          return StreamBuilder(
            stream: context.read<SavedCubit>().savedProductsStream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: const AppLoadingIndicator(size: 40, strokeWidth: 5),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error Has Occured: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: NoResultWidget(
                    icon: 'heart2',
                    title: 'No Saved Items!',
                    subTitle:
                        'You don’t have any saved items. Go to home and add some.',
                  ),
                );
              } else {
                final List<Product> listOfProducts = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 19,
                    childAspectRatio:
                        172 / (MediaQuery.of(context).size.width - 68 / 2),
                  ),
                  shrinkWrap: true,
                  itemCount: listOfProducts.length,
                  itemBuilder: (context, index) {
                    final Product product = listOfProducts[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      ),
                      child: SavedProductWidget(product: product),
                    );
                  },
                );
              }
            },
          );
        } else {
          return Center(
            child: Text(
              'Something went wrong please try again later... ${state.errorMessage}',
            ),
          );
        }
      },
    );
  }
}