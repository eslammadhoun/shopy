import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/home/Domain/entites/product.dart';
import 'package:shopy/features/home/Domain/entites/recent_search.dart';
import 'package:shopy/features/home/Domain/use_cases/add_to_recent_searches.dart';
import 'package:shopy/features/home/Domain/use_cases/delete_history.dart';
import 'package:shopy/features/home/Domain/use_cases/delete_search_case.dart';
import 'package:shopy/features/home/Domain/use_cases/get_recent_searches.dart';
import 'package:shopy/features/home/Domain/use_cases/search_usecase.dart';
import 'package:shopy/features/home/presentation/cubit/search_cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUsecase searchUsecase;
  final AddToRecentSearches addToRecentSearchesUsecase;
  final GetRecentSearches getRecentSearchesUsecase;
  final DeleteSearchCase deleteSearchCaseUsecase;
  final DeleteSearchHistory deleteSearchHistoryUsecase;
  Timer? _debounce;

  Stream<List<Product>>? _searchResultStream;
  Stream<List<RecentSearch>>? _recentSearchesStream;

  Stream<List<Product>>? get searchResultStream => _searchResultStream;
  Stream<List<RecentSearch>>? get recentSearchStream => _recentSearchesStream;

  SearchCubit({
    required this.searchUsecase,
    required this.addToRecentSearchesUsecase,
    required this.getRecentSearchesUsecase,
    required this.deleteSearchCaseUsecase,
    required this.deleteSearchHistoryUsecase,
  }) : super(SearchState.initial());

  void reset() {
    emit(
      state.copyWith(
        searchState: SearchStates.initial,
        recentSearchState: RecentSearchStates.success,
      ),
    );
  }

  Future<void> search({required String searchQuery}) async {
    _debounce?.cancel();

    if (searchQuery.trim().isEmpty) {
      reset();
      return;
    }

    emit(
      state.copyWith(searchState: SearchStates.searching),
    );

    _debounce = Timer((const Duration(milliseconds: 300)), () async {
      final Either<Failure, Stream<List<Product>>> result = await searchUsecase(
        searchQuery: searchQuery,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            searchState: SearchStates.searchingFaield,
            errorMessage: failure.message,
          ),
        ),
        (success) {
          _searchResultStream = success;
          emit(state.copyWith(searchState: SearchStates.searchingSuccess));
        },
      );
    });
  }

  Future<void> getRecentSearchesStream() async {
    emit(state.copyWith(recentSearchState: RecentSearchStates.loading));
    final Either<Failure, Stream<List<RecentSearch>>> result =
        await getRecentSearchesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          recentSearchState: RecentSearchStates.error,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        _recentSearchesStream = success;
        emit(state.copyWith(recentSearchState: RecentSearchStates.success));
      },
    );
  }

  Future<void> addToRecentSearches({required String searchQuery}) async {
    final Either<Failure, void> result = await addToRecentSearchesUsecase(
      searchQuery: searchQuery,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (success) {},
    );
  }

  Future<bool> deleteSearchCase({required String searchCaseId}) async {
    final Either<Failure, void> result = await deleteSearchCaseUsecase(
      searchCaseId: searchCaseId,
    );
    return result.fold(
      (failure) {
        return false;
      },
      (success) {
        return true;
      },
    );
  }

  Future<bool> deleteSearchHistory() async {
    final Either<Failure, void> result = await deleteSearchHistoryUsecase();
    return result.fold(
      (failure) {
        return false;
      },
      (success) {
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
