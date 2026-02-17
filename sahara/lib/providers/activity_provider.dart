import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

/// Provider for activity state management
class ActivityProvider with ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<ActivityModel>>? _activitiesSubscription;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load activities for a booking
  Future<void> loadActivities(String bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _activities = await _repository.getBookingActivities(bookingId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Subscribe to real-time activity updates
  void subscribeToActivities(String bookingId) {
    _activitiesSubscription?.cancel();
    _activitiesSubscription = _repository
        .getBookingActivitiesStream(bookingId)
        .listen(
          (activities) {
            _activities = activities;
            _error = null;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  /// Unsubscribe from activity updates
  void unsubscribeFromActivities() {
    _activitiesSubscription?.cancel();
    _activitiesSubscription = null;
  }

  /// Create a new activity
  Future<String?> createActivity(ActivityModel activity) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final activityId = await _repository.createActivity(activity);
      _isLoading = false;
      notifyListeners();
      return activityId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Delete activity
  Future<bool> deleteActivity({
    required String bookingId,
    required String activityId,
  }) async {
    try {
      await _repository.deleteActivity(
        bookingId: bookingId,
        activityId: activityId,
      );
      
      // Remove from local list
      _activities.removeWhere((a) => a.activityId == activityId);
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get activities by type
  List<ActivityModel> getActivitiesByType(String type) {
    return _activities.where((a) => a.type == type).toList();
  }

  /// Get photo activities
  List<ActivityModel> get photoActivities {
    return getActivitiesByType('photo');
  }

  /// Get text activities
  List<ActivityModel> get textActivities {
    return getActivitiesByType('text');
  }

  /// Get milestone activities
  List<ActivityModel> get milestoneActivities {
    return getActivitiesByType('milestone');
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear data
  void clear() {
    _activities = [];
    _error = null;
    _isLoading = false;
    unsubscribeFromActivities();
    notifyListeners();
  }

  @override
  void dispose() {
    unsubscribeFromActivities();
    super.dispose();
  }
}
