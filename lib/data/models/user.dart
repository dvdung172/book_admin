import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final String? image;
  final int role;
  final DateTime? createdAt;

  User({
    required this.uid,
    required this.name,
    required this.image,
    required this.address,
    required this.phone,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(String id,Map<String, dynamic> data) => User(
    uid: data['uid'],
    name: data['name'],
    image: data['image'],
    address: data['address'],
    phone: data['phone'],
    email: data['email'],
    role: int.parse('${data['role'] ?? '0'}'),
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, Object?> toJson() => {
    "uid": uid,
    "name": name,
    "image": image,
    "address": address,
    "phone": phone,
    "role": role,
    "email": email,
    "createdAt": Timestamp.fromDate(createdAt!),
  };
}