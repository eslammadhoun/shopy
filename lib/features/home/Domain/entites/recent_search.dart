import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearch {
  final String recentSearchId;
  final String searchQuery;
  final Timestamp timeStamp;
  const RecentSearch({required this.recentSearchId, required this.searchQuery, required this.timeStamp});
}