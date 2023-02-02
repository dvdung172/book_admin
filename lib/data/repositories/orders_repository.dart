import 'dart:async';
import 'dart:typed_data';

import 'package:client/data/models/order.dart';
import 'package:client/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('oders').withConverter<ProductOrder>(
    fromFirestore: (snapshot, _) => ProductOrder.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (productOrder, _) => productOrder.toJson(),
  );
  Stream<QuerySnapshot<Object?>> getAllOrdersWithStream({required String filter})  {
    final searchdata = collection
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: filter +'z')
        // .orderBy('createdAt', descending: true)
        .snapshots();
    final data = collection
        .snapshots();
    return filter.isNotEmpty ? searchdata : data;
  }
  Future<List<ProductOrder>> getOrderbyUser({required String uId}) async {
    final snapshot =
    await collection.where('uId', isEqualTo: uId).get();
    return snapshot.docs
        .map(
          (doc) => doc.data()! as ProductOrder,
    ).toList();
  }
  Future<int> sumOrder() async {
    var count = 0;
    await collection.get().then((value) {
      for (var element in value.docs) {
        int value = (element.data()! as ProductOrder).amount!;
        count = count + value;
      }
      print(count);
    });
    return count;
  }

  Future<List<Map<String, dynamic>>> getOrderSummary({required List<Item> data}) async {
    List<Map<String, dynamic>> list = [];
    for(var item in data){
      var doc = await FirebaseFirestore.instance.doc(item.product.path).withConverter<Product>(
        fromFirestore: (snapshot, _) => Product.fromJson(snapshot.id,snapshot.data()!),
        toFirestore: (product, _) => product.toJson(),
      ).get();
      Map<String, dynamic> map = {
        "product": doc.data(),
        "quantity": item.quantity,
      };
      list.add(map);
    }
    return list;
  }

  Future<void> updateStatus({required String id, required String value}) async {
    await collection.doc(id).update({'status' : value});
  }

  Future<int> countCollecion() async {
    AggregateQuerySnapshot query = await collection.count().get();
    return query.count;
  }
}