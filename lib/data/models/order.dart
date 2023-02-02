import 'package:client/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Item{
  final DocumentReference product;
  final int quantity;
  Item({
    required this.product,
    required this.quantity,
  });
  factory Item.fromJson(Map<String, dynamic> data) => Item(
    product: data['product'],
    quantity: data['quantity'],
  );

  Map<String, Object?> toJson() => {
    "product": product,
    "quantity": quantity,
  };
}

class ProductOrder {
  final String? id;
  final String? uId;
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final int? amount;
  final String? status;
  final List<Item>? item;
  final DateTime? orderDate;

  ProductOrder( {
    this.id,
    required this.uId,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.amount,
    required this.status,
    required this.item,
    required this.orderDate,
  });
//
  factory ProductOrder.fromJson(String id,Map<String, dynamic> data) => ProductOrder(
    id: id,
    uId: data['uId'] ?? "",
    name: data['name'] ?? "",
    phone: data['phone'] ?? "",
    email: data['email'] ?? "",
    address: data['address'] ?? "",
    status: data['status'] ?? "",
    amount: int.parse('${data['amount'] ?? '0'}'),
    orderDate: (data['date'] as Timestamp).toDate(),
    item: List<dynamic>.from(data['item'])
        .map((i) => Item.fromJson(i))
        .toList(),
  );

  Map<String, Object?> toJson() => {
    "id": id,
    "uId": uId,
    "name": name,
    "phone": phone,
    "email": email,
    "address": address,
    "status": status,
    "amount": amount,
    "orderDate": orderDate,
    "item": item,
  };
}