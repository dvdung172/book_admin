import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  final String? id;
  final String? name;
  final String? email;
  final String? address;
  final String? phone;
  final String? image;
  final DateTime? registerDate;

  Customer( {
    this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.image,
    required this.registerDate,
  });

  factory Customer.fromJson(String id,Map<String, dynamic> data) => Customer(
    id: id,
    name: data['name'] ?? "",
    email: data['email'] ?? "",
    address: data['address'] ?? "",
    phone: data['phone'] ?? "",
    image: data['image'] ?? "",
    registerDate: (data['registerDate'] as Timestamp).toDate(),
  );

  Map<String, Object?> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "image": image,
    "registerDate": Timestamp.fromDate(registerDate!),
  };
}