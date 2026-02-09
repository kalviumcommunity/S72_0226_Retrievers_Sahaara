import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/pet_model.dart';

/// Repository for managing pet data
class PetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Create a new pet profile
  Future<String> createPet(PetModel pet) async {
    try {
      final docRef = await _firestore.collection('pets').add(pet.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create pet profile: $e');
    }
  }

  /// Get all pets for an owner
  Future<List<PetModel>> getOwnerPets(String ownerId) async {
    try {
      final snapshot = await _firestore
          .collection('pets')
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => PetModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get pets: $e');
    }
  }

  /// Get a single pet by ID
  Future<PetModel?> getPet(String petId) async {
    try {
      final doc = await _firestore.collection('pets').doc(petId).get();
      
      if (doc.exists) {
        return PetModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get pet: $e');
    }
  }

  /// Update pet profile
  Future<void> updatePet(String petId, PetModel pet) async {
    try {
      await _firestore.collection('pets').doc(petId).update(pet.toMap());
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  /// Delete pet profile
  Future<void> deletePet(String petId) async {
    try {
      await _firestore.collection('pets').doc(petId).delete();
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  /// Upload pet photo
  Future<String> uploadPetPhoto({
    required String petId,
    required File imageFile,
  }) async {
    try {
      // Create reference to storage location
      final ref = _storage.ref().child('pets/$petId/photo.jpg');

      // Upload file
      final uploadTask = await ref.putFile(imageFile);

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload pet photo: $e');
    }
  }
}
