import 'dart:async';
import 'dart:typed_data';

import 'package:client/data/models/customer.dart';
import 'package:client/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:universal_io/io.dart';

class CustomerRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('customers').withConverter<Customer>(
    fromFirestore: (snapshot, _) => Customer.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (customer, _) => customer.toJson(),
  );
  Stream<QuerySnapshot<Object?>> getAllCustomersWithStream({required String filter})  {
    final searchdata = collection
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: filter +'z')
        // .orderBy('createdAt', descending: true)
        .snapshots();
    final data = collection
        .snapshots();

    return filter.isNotEmpty ? searchdata : data;
  }
  Future<void> createCustomer({ required String name, required Uint8List? image, required String phone, required String email,required String address,}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    final _customer = Customer(name: name, email: email, address: address, phone: phone, image: '', registerDate: DateTime.now());
    await collection.add(_customer).then((value) async {
      if(image != null){
        //image name
        String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
        // storage reference
        Reference referenceDirImage = FirebaseStorage.instance.ref().child('images/');
        //upload
        Reference referenceImageToUpload = referenceDirImage.child(uniqueName);
        try {
          await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
              .whenComplete(() async {
            final _fileURL = await referenceImageToUpload.getDownloadURL();
            await collection.doc(value.id).update({'image': _fileURL });
            EasyLoading.showSuccess(' Success!');
          });
        } catch (error) {
          EasyLoading.showSuccess('Create Customer without image');
        }
      } else
        {
          EasyLoading.showSuccess('Create Customer without image');
        }
    });

  }
  Future<void> updateCustomer({required Customer customer, required String name, required Uint8List? image, required String phone, required String email,required String address, }) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(customer.id!).update({
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
    }).then((value) async {
      if(image != null){
        if(customer.image == "" || customer.image == null){
          //image name
          String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
          // storage reference2
          Reference referenceDirImage = FirebaseStorage.instance.ref().child('images/');
          //upload
          Reference referenceImageToUpload = referenceDirImage.child(uniqueName);
          try {
            File createFileFromBytes = File.fromRawPath(image!);
            await referenceImageToUpload.putFile(createFileFromBytes,SettableMetadata(contentType: 'image/png'),)
                .whenComplete(() async {
              final _fileURL = await referenceImageToUpload.getDownloadURL();
              await collection.doc(customer.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Customer without image');
          }
        } else {
          Reference referenceImageToUpload = FirebaseStorage.instance.refFromURL(customer.image!);
          try {
            await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
                .whenComplete(() async {
              final _fileURL = await referenceImageToUpload
                  .getDownloadURL();
              await collection.doc(customer.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Customer without image');
          }
        }

      } else {
      EasyLoading.showSuccess('Create Customer without image');
      }
    });

  }

  Future<void> isActivedCustomer({required String id, required bool value}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).update({'isActived' : value});
    EasyLoading.dismiss();

  }
  Future<void> deleteCustomer({required String id}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).delete();
    EasyLoading.showSuccess(' Success!');

  }
  Future<int> countCollecion() async {
    AggregateQuerySnapshot query = await collection.count().get();
    return query.count;
  }

}