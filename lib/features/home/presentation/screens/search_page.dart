import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopy/core/theme/app_colors.dart';
import 'package:shopy/core/theme/app_text_style.dart';
import 'package:shopy/core/widgets/app_snack_bar.dart';
import 'package:shopy/core/widgets/loading_indecator.dart';
import 'package:shopy/core/widgets/no_result.dart';
import 'package:shopy/core/widgets/search_field.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/entites/recent_search.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/home_cubit/home_state.dart';
import 'package:shopy/features/home/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:shopy/features/home/presentation/cubit/search_cubit/search_state.dart';
import 'package:shopy/features/home/presentation/screens/product_details.dart';
import 'package:shopy/features/home/presentation/widgets/product_search_result.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      await context.read<SearchCubit>().getRecentSearchesStream();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 65),
            _buildTitleSection(context),
            SizedBox(height: 20),
            SearchField(
              onFieldSubmitted: (value) => context
                  .read<SearchCubit>()
                  .addToRecentSearches(searchQuery: value),
              onChanged: (newValue) => context.read<SearchCubit>().search(
                searchQuery: searchController.text,
              ),
              controller: searchController,
              width: MediaQuery.of(context).size.width - 48,
              prefix: 'search',
              hintText: 'Search for clothes...',
              haseSuffix: true,
            ),
            SizedBox(height: 20),
            _buildSearchResultSection(context),
          ],
        ),
      ),
    );
  }

  // title section
  Widget _buildTitleSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: .center,
      children: [
        BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, state) {
            return GestureDetector(
              onTap: () {
                context.read<HomeCubit>().changeSelectedPage(newIndex: 0);
                context.read<SearchCubit>().reset();
                searchController.clear();
              },
              child: Icon(Icons.arrow_back, size: 30),
            );
          },
        ),

        Text(
          'Search',
          style: AppTextStyle.h3SemiBold.copyWith(
            color: AppColors.primary900Color,
          ),
        ),
        GestureDetector(
          child: SvgPicture.asset('lib/assets/icons/bell.svg', width: 26),
          onTap: () =>
              context.read<HomeCubit>().changeSelectedPage(newIndex: 5),
        ),
      ],
    );
  }

  Widget _buildSearchResultSection(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Expanded(
          child: Center(
            child: switch (state.searchState) {
              SearchStates.initial => _buildRecentSearchesSection(context),
              SearchStates.searching => const AppLoadingIndicator(
                size: 60,
                strokeWidth: 8,
              ),

              SearchStates.searchingFaield => Text(
                'Something Went Wrong: ${state.errorMessage}',
                textAlign: TextAlign.center,
              ),

              SearchStates.searchingSuccess => StreamBuilder(
                stream: context.read<SearchCubit>().searchResultStream,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoadingIndicator(size: 60, strokeWidth: 8);
                  } else if (snapshot.hasError) {
                    return Text(
                      'Something Went Wrong: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return NoResultWidget(
                      icon: 'search2',
                      title: 'No Results Found!',
                      subTitle: 'Try a similar word or something more general.',
                    );
                  } else {
                    final List<Product> listOfProducts = snapshot.data!;
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: listOfProducts.length,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: listOfProducts[index],
                              ),
                            ),
                          ),
                          child: ProductSearchResult(
                            product: listOfProducts[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(
                          color: AppColors.primary100Color,
                          thickness: 1,
                        ),
                      ),
                    );
                  }
                },
              ),
            },
          ),
        );
      },
    );
  }

  Widget _buildRecentSearchesSection(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (BuildContext context, state) {
        if (state.recentSearchState == RecentSearchStates.success) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text('Recent Searches', style: AppTextStyle.h4SemiBold),
                  GestureDetector(
                    onTap: () async =>
                        await context.read<SearchCubit>().deleteSearchHistory(),
                    child: Text(
                      'Clear all',
                      style: AppTextStyle.b2Medium.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream: context.read<SearchCubit>().recentSearchStream,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: AppLoadingIndicator(size: 40, strokeWidth: 5),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Faild to Fetch Recent Searches: ${snapshot.error}',
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: NoResultWidget(
                          icon: 'search2',
                          title: 'No Recent Searches!',
                          subTitle:
                              'Discover the app to see the buty of shopping',
                        ),
                      );
                    } else {
                      final List<RecentSearch> list = snapshot.data!;
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final RecentSearch recentSearch = list[index];
                          return _buildResentSearchItem(
                            context,
                            recentSearch.searchQuery,
                            recentSearch.recentSearchId,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemCount: list.length,
                      );
                    }
                  },
                ),
              ),
            ],
          );
        } else if (state.recentSearchState == RecentSearchStates.loading) {
          return AppLoadingIndicator(size: 40, strokeWidth: 5);
        } else {
          return Center(child: Text(state.errorMessage ?? 'error Message'));
        }
      },
    );
  }

  Widget _buildResentSearchItem(
    BuildContext context,
    String searchName,
    String searchCaseId,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                searchController.text = searchName;
                context.read<SearchCubit>().search(searchQuery: searchName);
              },
              child: Text(
                searchName,
                style: AppTextStyle.b1Regular.copyWith(
                  color: AppColors.primary900Color,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final bool result = await context
                    .read<SearchCubit>()
                    .deleteSearchCase(searchCaseId: searchCaseId);
                if (result) {
                  if (context.mounted) {
                    AppSnackBar.show(
                      context,
                      message: 'Recent Search Deleted!',
                      type: SnackBarType.success,
                    );
                  }
                }
              },
              child: SvgPicture.asset('lib/assets/icons/Cancel-circle.svg'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Divider(color: AppColors.primary100Color, thickness: 1),
      ],
    );
  }
}
