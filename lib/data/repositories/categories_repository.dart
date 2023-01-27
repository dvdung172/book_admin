import 'dart:async';

import 'package:client/data/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class CategoryRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('categories').withConverter<Category>(
    fromFirestore: (snapshot, _) => Category.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (category, _) => category.toJson(),
  );

  void getsAllCategories() async {
    await collection.get().then((event) {
      print(event.docs);
      // for (var doc in event.docs) {
      //   print("${docs} => ${(doc.data() as Category).createdAt}");
      // }
    });
  }
  Future<List<QueryDocumentSnapshot<Object?>>> getAllCategories() async {
    final data = (await collection.get()).docs;
    return data;
  }
  // Stream<QuerySnapshot> getMatches() {
  //   var timestamp = Timestamp.fromMillisecondsSinceEpoch(
  //       DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch);
  //   var timestamp2 = Timestamp.fromMillisecondsSinceEpoch(
  //       DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch);
  //   // return collection.where('time' , isEqualTo : '2').snapshots();
  //   return collection
  //       .where('timematches', isLessThanOrEqualTo: timestamp2)
  //       .orderBy('timematches', descending: false)
  //       .startAt([timestamp]).snapshots();
  // }
  //
  // Stream<DocumentSnapshot> getVote({required String id, required String user}) {
  //   return collection.doc(id).collection('votes').doc(user).snapshots();
  // }
  //
  // Future<void> addMatch({
  //   required String id,
  //   required String team1,
  //   required String team2,
  //   required DateTime timematches,
  // }) {
  //   return collection
  //       .doc(id)
  //       .set({
  //     'team1': team1,
  //     'team2': team2,
  //     'timematches': timematches // 42
  //   })
  //       .then((value) {
  //     for (var user in users) {
  //       collection.doc(id).collection('votes').doc(user).set({
  //         'timevote': DateTime.now(),
  //         'vote': 0,
  //       });
  //     }
  //   })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }
  //
  // // void updateVote(Votes vote) async {
  // //   await collection.doc('${vote.id}').update(vote.toJson());
  // // }
  // Future<void> updateVote({
  //   required String id,
  //   required int vote,
  //   required String user,
  // }) {
  //   return collection
  //       .doc(id)
  //       .collection('votes')
  //       .doc(user)
  //       .update({
  //     'vote': vote,
  //     'timevote': DateTime.now() // 42
  //   })
  //       .then((value) => print("User Update"
  //       "d"))
  //       .catchError((error) => print("Failed to update user: $error"));
  // }
  //
  // // void Delete(String id) async {
  // //   // await collection.doc('${vote.id}').delete();
  // //   await collection.doc('${id}').delete();
  // // }
  //
  // Future<void> batchDelete() async {
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //
  //   FirebaseFirestore.instance.collection("11222").get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((document) {
  //       print(document.id);
  //     });
  //     return batch.commit();
  //   });
  // }
}