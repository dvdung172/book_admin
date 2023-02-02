import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? id;
  final String? name;
  final String? author;
  final String? category;
  final String? publisher;
  final String? description;
  final String? image;
  final int? price;
  final int? stock;
  final bool isActived;
  final DateTime? createdAt;

  Product( {
    this.id,
    required this.name,
    required this.author,
    required this.category,
    required this.publisher,
    required this.description,
    required this.image,
    required this.price,
    required this.stock,
    required this.isActived,
    required this.createdAt,
  });

  factory Product.fromJson(String id,Map<String, dynamic> data) => Product(
    id: id,
    name: data['name'] ?? "",
    author: data['author'] ?? "",
    category: data['category'] ?? "",
    publisher: data['publisher'] ?? "",
    description: data['description'] ?? "",
    image: data['image'] ?? "",
    price: int.parse('${data['price'] ?? '0'}'),
    stock: int.parse('${data['stock'] ?? '0'}'),
    isActived: data['isActived'] ,
    createdAt: (data['createdAt'] as Timestamp).toDate(),
  );

  Map<String, Object?> toJson() => {
    "name": name,
    "author": author,
    "category": category,
    "publisher": publisher,
    "description": description,
    "image": image,
    "price": price,
    "stock": stock,
    "isActived": isActived,
    "createdAt": Timestamp.fromDate(createdAt!),
  };
}