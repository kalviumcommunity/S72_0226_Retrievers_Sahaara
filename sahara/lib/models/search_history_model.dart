import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for search history
class SearchHistoryModel {
  final String id;
  final String userId;
  final String searchQuery;
  final Map<String, dynamic>? filters;
  final DateTime createdAt;

  SearchHistoryModel({
    required this.id,
    required this.userId,
    required this.searchQuery,
    this.filters,
    required this.createdAt,
  });

  /// Create from Firestore document
  factory SearchHistoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SearchHistoryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      searchQuery: data['searchQuery'] ?? '',
      filters: data['filters'] as Map<String, dynamic>?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'searchQuery': searchQuery,
      'filters': filters,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Get display text
  String get displayText {
    if (searchQuery.isEmpty && filters != null && filters!.isNotEmpty) {
      return 'Filtered search';
    }
    return searchQuery;
  }
}
