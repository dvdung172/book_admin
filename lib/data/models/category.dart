import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String? id;
  final String? name;
  final String? image;
  final DateTime? createdAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
  });

  factory Category.fromJson(String id,Map<String, dynamic> data) => Category(
    id: id,
    name: data['name'],
    image: data['image'],
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, Object?> toJson() => {
    "name": name,
    "image": image,
    "createdAt": Timestamp.fromDate(createdAt!),
  };
}