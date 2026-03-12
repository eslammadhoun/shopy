import 'package:equatable/equatable.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';

enum HomeStates {
  initial,
  loadingProducts,
  productsLoadded,
  error,
  favouriteStateChanged,
}

enum HomeUiEvent {none, favouriteAdded, favouriteRemoved}

class HomeState extends Equatable {
  final int selectedPage;
  final HomeStates homeState;
  final String? errorMessage;
  final Stream<List<Product>>? productsStream;
  final HomeUiEvent uiEvent;

  // products filter propertes
  final String? selectedFilter;
  final String selectedCategory;
  final Map<String, double>? priceRangeValues;
  final String? selectedSizeFilter;

  const HomeState({
    required this.selectedPage,
    required this.selectedCategory,
    required this.homeState,
    this.errorMessage,
    this.productsStream,
    required this.selectedFilter,
    required this.priceRangeValues,
    required this.selectedSizeFilter,
    required this.uiEvent,
  });

  factory HomeState.initial() {
    return HomeState(
      selectedPage: 0,
      selectedCategory: 'All',
      homeState: HomeStates.initial,
      errorMessage: null,
      productsStream: null,
      selectedFilter: null,
      priceRangeValues: null,
      selectedSizeFilter: null,
      uiEvent: HomeUiEvent.none,
    );
  }

  HomeState copyWith({
    int? selectedPage,
    String? selectedCategory,
    HomeStates? homeState,
    String? errorMessage,
    Stream<List<Product>>? productsStream,
    String? selectedFilter,
    Map<String, double>? priceRangeValues,
    String? selectedSizeFilter,
    HomeUiEvent? homeUiEvent,
  }) {
    return HomeState(
      selectedPage: selectedPage ?? this.selectedPage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      homeState: homeState ?? this.homeState,
      errorMessage: errorMessage ?? this.errorMessage,
      productsStream: productsStream ?? this.productsStream,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      priceRangeValues: priceRangeValues ?? this.priceRangeValues,
      selectedSizeFilter: selectedSizeFilter ?? this.selectedSizeFilter,
      uiEvent: homeUiEvent ?? uiEvent,
    );
  }

  HomeState withResetFilter({
    String? selectedFilter,
    Map<String, double>? priceRangeValues,
    String? selectedSizeFilter,
  }) {
    return HomeState(
      selectedPage: selectedPage,
      selectedCategory: selectedCategory,
      homeState: homeState,
      errorMessage: errorMessage,
      productsStream: productsStream,
      selectedFilter: selectedFilter,
      priceRangeValues: priceRangeValues,
      selectedSizeFilter: selectedSizeFilter,
      uiEvent: uiEvent,
    );
  }

  HomeState resetSearch() {
    return HomeState(
      selectedPage: selectedPage,
      selectedCategory: selectedCategory,
      homeState: homeState,
      errorMessage: errorMessage,
      productsStream: productsStream,
      selectedFilter: selectedFilter,
      priceRangeValues: priceRangeValues,
      selectedSizeFilter: selectedSizeFilter,
      uiEvent: uiEvent,
    );
  }

  @override
  List<Object?> get props => [
    selectedPage,
    selectedCategory,
    homeState,
    errorMessage,
    productsStream,
    selectedFilter,
    priceRangeValues,
    selectedSizeFilter,
    uiEvent,
  ];
}
