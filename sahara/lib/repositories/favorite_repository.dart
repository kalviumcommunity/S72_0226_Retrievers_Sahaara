import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';

/// Repository for favorite caregivers operations
class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'favorites';

  /// Add caregiver to favorites
  Future<String> addFavorite(String ownerId, String caregiverId) async {
    try {
      // Check if already favorited
      final existing = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .where('caregiverId', isEqualTo: caregiverId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        return existing.docs.first.id;
      }

      // Add new favorite
      final favorite = FavoriteModel(
        id: '',
        ownerId: ownerId,
        caregiverId: caregiverId,
        createdAt: DateTime.now(),
      );

      final docRef =
          await _firestore.collection(_collection).add(favorite.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  /// Remove caregiver from favorites
  Future<void> removeFavorite(String ownerId, String caregiverId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .where('caregiverId', isEqualTo: caregiverId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  /// Check if caregiver is favorited
  Future<bool> isFavorite(String ownerId, String caregiverId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .where('caregiverId', isEqualTo: caregiverId)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check favorite: $e');
    }
  }

  /// Get all favorite caregiver IDs for owner
  Future<List<String>> getFavoriteCaregiverIds(String ownerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['caregiverId'] as String)
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  /// Get all favorites for owner
  Future<List<FavoriteModel>> getFavorites(String ownerId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FavoriteModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  /// Stream favorites for owner
  Stream<List<FavoriteModel>> streamFavorites(String ownerId) {
    return _firestore
        .collection(_collection)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => FavoriteModel.fromFirestore(doc)).toList());
  }

  /// Get favorite count for caregiver
  Future<int> getFavoriteCount(String caregiverId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('caregiverId', isEqualTo: caregiverId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get favorite count: $e');
    }
  }
}
