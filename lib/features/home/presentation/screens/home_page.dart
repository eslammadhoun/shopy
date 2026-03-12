import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/global_button.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/search_field.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:shopy/features/home/presentation/screens/product_details.dart';
import 'package:shopy/features/home/presentation/widgets/catecory_button.dart';
import 'package:shopy/features/home/presentation/widgets/product_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const List<String> _categoriesNames = [
    'All',
    'Tshirts',
    'Jeans',
    'Shoes',
    'Hoodie',
  ];
  static const List<String> _filters = [
    'Relevance',
    'Price: Low - High',
    'Price: High - Low',
  ];

  static const List<String> _sizes = ['S', 'M', 'L', 'XL'];
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<HomeCubit>().getProductsStream(catecoryName: 'All');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: 65),
                    _buildTitleSection(context),
                    SizedBox(height: 16),
                    _buildSearchSection(context),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              _buildCategoriesSection(context, state.selectedCategory),
              SizedBox(height: 24),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _buildProductsList(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // first title section
  Widget _buildTitleSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Discover', style: AppTextStyle.h2SemiBold),
        GestureDetector(
          child: SvgPicture.asset('lib/assets/icons/bell.svg', width: 26),
          onTap: () =>
              context.read<HomeCubit>().changeSelectedPage(newIndex: 5),
        ),
      ],
    );
  }

  // search section
  Widget _buildSearchSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchField(
          width: MediaQuery.of(context).size.width - 108,
          onChanged: (value) {},
          prefix: 'search',
          hintText: 'Search for clothes...',
          haseSuffix: true,
        ),
        SizedBox(width: 8),
        InkWell(
          onTap: () => _buildFilterPopup(context),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary900Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset('lib/assets/icons/filter.svg'),
            ),
          ),
        ),
      ],
    );
  }

  // categories section
  Widget _buildCategoriesSection(
    BuildContext context,
    String selectedCategory,
  ) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (BuildContext context, state) {
        return Padding(
          padding: EdgeInsets.only(left: 24),
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: HomePage._categoriesNames.length,
              separatorBuilder: (context, index) => SizedBox(width: 8),
              itemBuilder: (context, index) => InkWell(
                onTap: () => context.read<HomeCubit>().changeSelectedCategory(
                  catecoryName: HomePage._categoriesNames[index],
                  sortBy: state.selectedFilter,
                  minPrice: state.priceRangeValues?['min'],
                  maxPrice: state.priceRangeValues?['max'],
                  productSize: state.selectedSizeFilter,
                ),
                child: CatecoryButton(
                  context: context,
                  categoryName: HomePage._categoriesNames[index],
                  isSelected:
                      selectedCategory == HomePage._categoriesNames[index],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // products list
  Widget _buildProductsList(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, state) {
        if (state.homeState == HomeStates.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state.uiEvent == HomeUiEvent.favouriteAdded) {
          AppSnackBar.show(
            context,
            message: 'Added to favourites',
            type: SnackBarType.success,
          );
        }
        if (state.uiEvent == HomeUiEvent.favouriteRemoved) {
          AppSnackBar.show(
            context,
            message: 'Removed from favourites',
            type: SnackBarType.success,
          );
        }
      },
      builder: (BuildContext context, state) {
        if (state.homeState == HomeStates.loadingProducts) {
          return Center(child: AppLoadingIndicator(size: 64, strokeWidth: 8));
        } else if (state.homeState == HomeStates.productsLoadded ||
            state.homeState == HomeStates.favouriteStateChanged) {
          return StreamBuilder(
            stream: state.productsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: AppLoadingIndicator(size: 48, strokeWidth: 6),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(
                  child: Text('Stream error: ${snapshot.error.toString()}'),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: NoResultWidget(
                    icon: 'cart2',
                    title: 'No Products Yet',
                    subTitle: 'The Admin Will Add Some Very Sooooooon.....',
                  ),
                );
              }
              final List<Product> listOfProducts = snapshot.data ?? [];
              return GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 175 / 244,
                ),
                itemCount: listOfProducts.length,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
                            product: listOfProducts[index],
                          ),
                        ),
                      ),
                      child: ProductWidget(
                        product: listOfProducts[index],
                        onTap: () =>
                            context.read<HomeCubit>().toggleFavoriteState(
                              productId: listOfProducts[index].productId,
                            ),
                      ),
                    ),
              );
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

  // filter widget
  void _buildFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        maxChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 64,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary100Color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (BuildContext context, state) {
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      controller: controller,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Filters',
                                    style: AppTextStyle.h4SemiBold,
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: SvgPicture.asset(
                                      'lib/assets/icons/cancel.svg',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color: AppColors.primary100Color,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text('Sort By', style: AppTextStyle.b1SemiBold),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 24, top: 12),
                          child: SizedBox(
                            height: 36,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: HomePage._filters.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 8),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  context
                                      .read<HomeCubit>()
                                      .changeSelectedFilter(
                                        newSelectedFilter:
                                            HomePage._filters[index],
                                      );
                                },
                                child: CatecoryButton(
                                  context: context,
                                  isSelected:
                                      state.selectedFilter ==
                                      HomePage._filters[index],
                                  categoryName: HomePage._filters[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  color: AppColors.primary100Color,
                                ),
                              ),
                              const SizedBox(height: 20),
                              state.selectedFilter == HomePage._filters[0]
                                  ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Price',
                                              style: AppTextStyle.b1SemiBold,
                                            ),
                                            Text(
                                              '\$ ${state.priceRangeValues?['min']!.toInt() ?? 0.0} - \$ ${state.priceRangeValues?['max']!.toInt() ?? 0.0}',
                                              style: AppTextStyle.b1Regular
                                                  .copyWith(
                                                    color: AppColors
                                                        .primary500Color,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            thumbColor:
                                                AppColors.primary900Color,
                                            activeTrackColor:
                                                AppColors.primary900Color,
                                            inactiveTrackColor:
                                                AppColors.primary100Color,
                                            rangeThumbShape:
                                                const RoundRangeSliderThumbShape(
                                                  enabledThumbRadius: 10,
                                                  elevation: 0,
                                                ),
                                            overlayColor: AppColors
                                                .primary900Color
                                                // ignore: deprecated_member_use
                                                .withOpacity(0.15),
                                          ),
                                          child: RangeSlider(
                                            values: RangeValues(
                                              state.priceRangeValues?['min']! ??
                                                  0.0,
                                              state.priceRangeValues?['max']! ??
                                                  0.0,
                                            ),
                                            min: 0,
                                            max: 3000,
                                            onChanged: (RangeValues values) =>
                                                context
                                                    .read<HomeCubit>()
                                                    .changePriceRange(
                                                      newPriceRange: {
                                                        'min': values.start,
                                                        'max': values.end,
                                                      },
                                                    ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary100Color,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Size',
                                              style: AppTextStyle.b1SemiBold,
                                            ),
                                            DropdownButton<String>(
                                              enableFeedback: true,
                                              dropdownColor:
                                                  AppColors.primary900Color,
                                              style: TextStyle(
                                                color:
                                                    AppColors.primary500Color,
                                              ),
                                              elevation: 1,
                                              value: state.selectedSizeFilter,
                                              underline: SizedBox(),
                                              isExpanded: false,
                                              icon: Icon(Icons.arrow_drop_down),
                                              items: HomePage._sizes
                                                  .map(
                                                    (size) => DropdownMenuItem(
                                                      value: size,
                                                      child: Text(
                                                        size,
                                                        style: AppTextStyle
                                                            .b1Regular
                                                            .copyWith(
                                                              color: AppColors
                                                                  .primary500Color,
                                                            ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newSize) => context
                                                  .read<HomeCubit>()
                                                  .changeSelectedSizeFilter(
                                                    newSize!,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  GlobalButton(
                                    width:
                                        MediaQuery.of(context).size.width - 126,
                                    backgroundColor: AppColors.primary900Color,
                                    border: BoxBorder.all(),
                                    onTap: () {
                                      context
                                          .read<HomeCubit>()
                                          .getProductsStream(
                                            catecoryName:
                                                state.selectedCategory,
                                            sortBy: state.selectedFilter,
                                            minPrice:
                                                state.priceRangeValues?['min'],
                                            maxPrice:
                                                state.priceRangeValues?['max'],
                                            productSize:
                                                state.selectedSizeFilter,
                                          );
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Apply Filters',
                                      style: AppTextStyle.b1Medium.copyWith(
                                        color: AppColors.background,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  GlobalButton(
                                    width: 58,
                                    backgroundColor: AppColors.primary900Color,
                                    border: BoxBorder.all(),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<HomeCubit>().ressetFilter();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: AppColors.background,
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
