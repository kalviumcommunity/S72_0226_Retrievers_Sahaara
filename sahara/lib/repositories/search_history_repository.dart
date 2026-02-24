import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/search_history_model.dart';

/// Repository for search history operations
class SearchHistoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'search_history';
  final int _maxHistoryItems = 20;

  /// Save search query
  Future<void> saveSearch(
    String userId,
    String searchQuery, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Don't save empty searches
      if (searchQuery.trim().isEmpty && (filters == null || filters.isEmpty)) {
        return;
      }

      // Check if this exact search already exists recently
      final recentSearch = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('searchQuery', isEqualTo: searchQuery)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      // If found within last hour, don't save duplicate
      if (recentSearch.docs.isNotEmpty) {
        final lastSearch = recentSearch.docs.first.data();
        final lastSearchTime = (lastSearch['createdAt'] as Timestamp).toDate();
        if (DateTime.now().difference(lastSearchTime).inHours < 1) {
          return;
        }
      }

      // Save new search
      final search = SearchHistoryModel(
        id: '',
        userId: userId,
        searchQuery: searchQuery,
        filters: filters,
        createdAt: DateTime.now(),
      );

      await _firestore.collection(_collection).add(search.toFirestore());

      // Clean up old searches (keep only last 20)
      await _cleanupOldSearches(userId);
    } catch (e) {
      throw Exception('Failed to save search: $e');
    }
  }

  /// Get search history for user
  Future<List<SearchHistoryModel>> getSearchHistory(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(_maxHistoryItems)
          .get();

      return querySnapshot.docs
          .map((doc) => SearchHistoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get search history: $e');
    }
  }

  /// Clear all search history for user
  Future<void> clearSearchHistory(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear search history: $e');
    }
  }

  /// Delete specific search
  Future<void> deleteSearch(String searchId) async {
    try {
      await _firestore.collection(_collection).doc(searchId).delete();
    } catch (e) {
      throw Exception('Failed to delete search: $e');
    }
  }

  /// Clean up old searches (keep only last N)
  Future<void> _cleanupOldSearches(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (querySnapshot.docs.length > _maxHistoryItems) {
        // Delete oldest searches
        for (int i = _maxHistoryItems; i < querySnapshot.docs.length; i++) {
          await querySnapshot.docs[i].reference.delete();
        }
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Get popular searches (most frequent)
  Future<List<String>> getPopularSearches(String userId, {int limit = 5}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      // Count frequency of each search query
      final searchCounts = <String, int>{};
      for (var doc in querySnapshot.docs) {
        final query = doc.data()['searchQuery'] as String;
        if (query.isNotEmpty) {
          searchCounts[query] = (searchCounts[query] ?? 0) + 1;
        }
      }

      // Sort by frequency and return top N
      final sortedSearches = searchCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return sortedSearches.take(limit).map((e) => e.key).toList();
    } catch (e) {
      return [];
    }
  }
}
