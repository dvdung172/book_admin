import 'package:cloud_firestore/cloud_firestore.dart';

class Publisher {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final DateTime? createdAt;

  Publisher({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory Publisher.fromJson(String id,Map<String, dynamic> data) => Publisher(
    id: id,
    name: data['name'],
    description: data['description'],
    image: data['image'],
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, Object?> toJson() => {
    "name": name,
    "description": description,
    "image": image,
    "createdAt": Timestamp.fromDate(createdAt!),
  };
}