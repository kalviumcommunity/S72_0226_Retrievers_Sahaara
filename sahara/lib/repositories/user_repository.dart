import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/user_model.dart';

/// Repository for managing user profile data
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get user profile by ID
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? profilePhoto,
    UserLocation? location,
  }) async {
    try {
      final Map<String, dynamic> updates = {};

      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (profilePhoto != null) updates['profilePhoto'] = profilePhoto;
      if (location != null) updates['location'] = location.toMap();
      
      updates['lastActive'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Upload profile photo
  Future<String> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // Create reference to storage location
      final ref = _storage.ref().child('users/$userId/profile.jpg');

      // Upload file
      final uploadTask = await ref.putFile(imageFile);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  /// Verify phone number
  Future<void> verifyPhoneNumber(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'phoneVerified': true,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to verify phone number: $e');
    }
  }

  /// Get user role
  Future<String?> getUserRole(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data()?['role'] as String?;
    } catch (e) {
      throw Exception('Failed to get user role: $e');
    }
  }

  /// Check if profile is complete
  Future<bool> isProfileComplete(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();
      
      if (data == null) return false;

      // Check required fields
      return data['name'] != null &&
             data['name'].toString().isNotEmpty &&
             data['phone'] != null &&
             data['phone'].toString().isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check profile completion: $e');
    }
  }
}
