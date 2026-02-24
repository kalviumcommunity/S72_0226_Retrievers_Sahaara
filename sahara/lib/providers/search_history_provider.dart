import 'package:flutter/foundation.dart';
import '../models/search_history_model.dart';
import '../repositories/search_history_repository.dart';

/// Provider for search history state management
class SearchHistoryProvider with ChangeNotifier {
  final SearchHistoryRepository _searchHistoryRepository =
      SearchHistoryRepository();

  List<SearchHistoryModel> _searchHistory = [];
  List<String> _popularSearches = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<SearchHistoryModel> get searchHistory => _searchHistory;
  List<String> get popularSearches => _popularSearches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Save search query
  Future<void> saveSearch(
    String userId,
    String searchQuery, {
    Map<String, dynamic>? filters,
  }) async {
    try {
      await _searchHistoryRepository.saveSearch(
        userId,
        searchQuery,
        filters: filters,
      );
      // Reload history after saving
      await loadSearchHistory(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Load search history
  Future<void> loadSearchHistory(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _searchHistory =
          await _searchHistoryRepository.getSearchHistory(userId);
      _popularSearches =
          await _searchHistoryRepository.getPopularSearches(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear all search history
  Future<bool> clearSearchHistory(String userId) async {
    try {
      await _searchHistoryRepository.clearSearchHistory(userId);
      _searchHistory = [];
      _popularSearches = [];
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete specific search
  Future<bool> deleteSearch(String userId, String searchId) async {
    try {
      await _searchHistoryRepository.deleteSearch(searchId);
      // Reload history after deletion
      await loadSearchHistory(userId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
