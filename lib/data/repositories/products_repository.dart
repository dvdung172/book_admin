import 'dart:async';
import 'dart:typed_data';

import 'package:client/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:universal_io/io.dart';

class ProductRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('products').withConverter<Product>(
    fromFirestore: (snapshot, _) => Product.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (product, _) => product.toJson(),
  );
  Stream<QuerySnapshot<Object?>> getAllProductsWithStream({required String filter})  {
    final searchdata = collection
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: filter +'z')
        // .orderBy('createdAt', descending: true)
        .snapshots();
    final data = collection
        .snapshots();

    return filter.isNotEmpty ? searchdata : data;
  }
  Future<void> createProduct({required String name, required Uint8List? image, required String description,required String author,required String category,required String publisher,required int price,required int stock,required bool isActived}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    final _product = Product( name: name, description: description, image: '', createdAt: DateTime.now(), author: author, category: category, publisher: publisher, price: price, stock: stock, isActived: isActived);
    await collection.add(_product).then((value) async {
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
          EasyLoading.showSuccess('Create Product without image');
        }
      } else
        {
          EasyLoading.showSuccess('Create Product without image');
        }
    });

  }
  Future<void> updateProduct({required Product product, required String name, required Uint8List? image, required String description,required String author,required String category,required String publisher,required int price,required int stock,required bool isActived}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(product.id!).update({
      "name": name,
      "description": description,
      "NXB": publisher,
      "author": author,
      "category": category,
      "isActived": isActived,
      "price": price,
      "stock": stock,
    }).then((value) async {
      if(image != null){
        if(product.image == "" || product.image == null){
          //image name
          String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
          // storage reference2
          Reference referenceDirImage = FirebaseStorage.instance.ref().child('images/');
          //upload
          Reference referenceImageToUpload = referenceDirImage.child(uniqueName);
          try {
            await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
                .whenComplete(() async {
              final _fileURL = await referenceImageToUpload.getDownloadURL();
              await collection.doc(product.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Publisher without image');
          }
        } else {
          Reference referenceImageToUpload = FirebaseStorage.instance.refFromURL(product.image!);
          try {
            File createFileFromBytes = File.fromRawPath(image!);
            await referenceImageToUpload.putFile(createFileFromBytes,SettableMetadata(contentType: 'image/png'),)
                .whenComplete(() async {
              final _fileURL = await referenceImageToUpload
                  .getDownloadURL();
              await collection.doc(product.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Publisher without image');
          }
        }

      } else {
      EasyLoading.showSuccess('Create Product without image');
      }
    });

  }

  Future<void> isActivedProduct({required String id, required bool value}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).update({'isActived' : value});
    EasyLoading.dismiss();

  }
  Future<void> deleteProduct({required String id}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).delete();
    EasyLoading.showSuccess(' Success!');

  }

  Future<int> countCollecion() async {
    AggregateQuerySnapshot query = await collection.count().get();
    return query.count;
  }
}