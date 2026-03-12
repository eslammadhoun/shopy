import 'package:equatable/equatable.dart';

// all search state
enum SearchStates { initial, searching, searchingSuccess, searchingFaield }

enum RecentSearchStates { initial, loading, success, error }

// search state class
class SearchState extends Equatable {
  // data fields
  final SearchStates searchState;
  final RecentSearchStates recentSearchState;
  final String? errorMessage;

  // constructor
  const SearchState({
    required this.searchState,
    required this.recentSearchState,
    this.errorMessage,
  });

  // initial object
  factory SearchState.initial() {
    return SearchState(
      searchState: SearchStates.initial,

      recentSearchState: RecentSearchStates.initial,
    );
  }

  SearchState copyWith({
    SearchStates? searchState,
    RecentSearchStates? recentSearchState,
    String? errorMessage,
  }) {
    return SearchState(
      searchState: searchState ?? this.searchState,
      recentSearchState: recentSearchState ?? this.recentSearchState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [searchState, recentSearchState, errorMessage];
}
