import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/caregiver_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

/// Repository for caregiver data operations
class CaregiverRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all active caregivers
  Future<List<CaregiverModel>> getAllCaregivers() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch caregivers: $e');
    }
  }

  /// Search caregivers by location (within radius)
  Future<List<CaregiverModel>> searchCaregiversByLocation({
    required GeoPoint userLocation,
    double radiusKm = 10.0,
  }) async {
    try {
      // Get all active caregivers
      final caregivers = await getAllCaregivers();

      // Filter by distance (simple implementation)
      // In production, use GeoFlutterFire or similar for efficient geo queries
      final filtered = caregivers.where((caregiver) {
        // For now, return all caregivers
        // TODO: Implement actual distance calculation
        return true;
      }).toList();

      return filtered;
    } catch (e) {
      throw Exception('Failed to search caregivers: $e');
    }
  }

  /// Search caregivers by services
  Future<List<CaregiverModel>> searchCaregiversByServices({
    required List<String> services,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('isActive', isEqualTo: true)
          .where('servicesOffered', arrayContainsAny: services)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search caregivers by services: $e');
    }
  }

  /// Search caregivers by pet types
  Future<List<CaregiverModel>> searchCaregiversByPetTypes({
    required List<String> petTypes,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('isActive', isEqualTo: true)
          .where('petTypesHandled', arrayContainsAny: petTypes)
          .get();

      return snapshot.docs
          .map((doc) => CaregiverModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search caregivers by pet types: $e');
    }
  }

  /// Get caregiver by ID
  Future<CaregiverModel?> getCaregiverById(String caregiverId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .get();

      if (doc.exists) {
        return CaregiverModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch caregiver: $e');
    }
  }

  /// Get caregiver by user ID
  Future<CaregiverModel?> getCaregiverByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.caregiversCollection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return CaregiverModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch caregiver by user ID: $e');
    }
  }

  /// Get caregiver with user details
  Future<Map<String, dynamic>?> getCaregiverWithUserDetails(
    String caregiverId,
  ) async {
    try {
      final caregiver = await getCaregiverById(caregiverId);
      if (caregiver == null) return null;

      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(caregiver.userId)
          .get();

      if (!userDoc.exists) return null;

      final user = UserModel.fromFirestore(userDoc);

      return {
        'caregiver': caregiver,
        'user': user,
      };
    } catch (e) {
      throw Exception('Failed to fetch caregiver with user details: $e');
    }
  }

  /// Get all caregivers with user details
  Future<List<Map<String, dynamic>>> getAllCaregiversWithUserDetails() async {
    try {
      final caregivers = await getAllCaregivers();
      final List<Map<String, dynamic>> results = [];

      for (final caregiver in caregivers) {
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(caregiver.userId)
            .get();

        if (userDoc.exists) {
          final user = UserModel.fromFirestore(userDoc);
          results.add({
            'caregiver': caregiver,
            'user': user,
          });
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to fetch caregivers with user details: $e');
    }
  }

  /// Filter caregivers by multiple criteria
  Future<List<Map<String, dynamic>>> filterCaregivers({
    List<String>? services,
    List<String>? petTypes,
    double? minRating,
    double? maxHourlyRate,
    int? minExperience,
  }) async {
    try {
      var caregivers = await getAllCaregiversWithUserDetails();

      // Apply filters
      if (services != null && services.isNotEmpty) {
        caregivers = caregivers.where((item) {
          final caregiver = item['caregiver'] as CaregiverModel;
          return services.any((service) =>
              caregiver.servicesOffered.contains(service));
        }).toList();
      }

      if (petTypes != null && petTypes.isNotEmpty) {
        caregivers = caregivers.where((item) {
          final caregiver = item['caregiver'] as CaregiverModel;
          return petTypes.any((type) =>
              caregiver.petTypesHandled.contains(type));
        }).toList();
      }

      if (minRating != null) {
        caregivers = caregivers.where((item) {
          final caregiver = item['caregiver'] as CaregiverModel;
          return caregiver.stats.averageRating >= minRating;
        }).toList();
      }

      if (maxHourlyRate != null) {
        caregivers = caregivers.where((item) {
          final caregiver = item['caregiver'] as CaregiverModel;
          return caregiver.hourlyRate <= maxHourlyRate;
        }).toList();
      }

      if (minExperience != null) {
        caregivers = caregivers.where((item) {
          final caregiver = item['caregiver'] as CaregiverModel;
          return caregiver.experienceYears >= minExperience;
        }).toList();
      }

      return caregivers;
    } catch (e) {
      throw Exception('Failed to filter caregivers: $e');
    }
  }

  /// Update caregiver stats
  Future<void> updateCaregiverStats({
    required String caregiverId,
    required CaregiverStats stats,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.caregiversCollection)
          .doc(caregiverId)
          .update({'stats': stats.toMap()});
    } catch (e) {
      throw Exception('Failed to update caregiver stats: $e');
    }
  }
}
