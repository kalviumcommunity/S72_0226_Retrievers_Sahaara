import 'package:cloud_firestore/cloud_firestore.dart';

/// Pet model representing a user's pet
class PetModel {
  final String petId;
  final String ownerId;
  final String name;
  final String type; // 'dog', 'cat', 'bird', 'other'
  final String breed;
  final int age;
  final double weight;
  final String gender; // 'male' or 'female'
  final String? photo;
  final String? specialNeeds;
  final String? medicalInfo;
  final DateTime createdAt;

  PetModel({
    required this.petId,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.weight,
    required this.gender,
    this.photo,
    this.specialNeeds,
    this.medicalInfo,
    required this.createdAt,
  });

  /// Create PetModel from Firestore document
  factory PetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PetModel(
      petId: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? 'dog',
      breed: data['breed'] ?? '',
      age: data['age'] ?? 0,
      weight: (data['weight'] ?? 0).toDouble(),
      gender: data['gender'] ?? 'male',
      photo: data['photo'],
      specialNeeds: data['specialNeeds'],
      medicalInfo: data['medicalInfo'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert PetModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'weight': weight,
      'gender': gender,
      'photo': photo,
      'specialNeeds': specialNeeds,
      'medicalInfo': medicalInfo,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy with updated fields
  PetModel copyWith({
    String? petId,
    String? ownerId,
    String? name,
    String? type,
    String? breed,
    int? age,
    double? weight,
    String? gender,
    String? photo,
    String? specialNeeds,
    String? medicalInfo,
    DateTime? createdAt,
  }) {
    return PetModel(
      petId: petId ?? this.petId,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      photo: photo ?? this.photo,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
