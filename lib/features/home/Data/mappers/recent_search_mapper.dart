import 'package:shopy/features/home/Data/models/recent_search_model.dart';
import 'package:shopy/features/home/Domain/entites/recent_search.dart';

class RecentSearchMapper {
  // From RecentSearchModel => Recent Search Entity
  static RecentSearch toRecentSearchEntity({required RecentSearchModel model}) {
    return RecentSearch(
      recentSearchId: model.recentSearchId,
      searchQuery: model.searchQuery,
      timeStamp: model.timestamp,
    );
  }
}
