import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearchModel {
  final String recentSearchId;
  final String searchQuery;
  final Timestamp timestamp;
  const RecentSearchModel({
    required this.recentSearchId,
    required this.searchQuery,
    required this.timestamp
  });

  // Deserialization (From Map => Dart Object)
  factory RecentSearchModel.fromJson(Map<String, dynamic> map) {
    return RecentSearchModel(
      recentSearchId: map['search_query_id'],
      searchQuery: map['search_query'],
      timestamp: map['createdAt']
    );
  }
}
