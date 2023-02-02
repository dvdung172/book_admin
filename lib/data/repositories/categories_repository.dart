import 'dart:async';
import 'dart:typed_data';

import 'package:client/data/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

class CategoryRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('categories').withConverter<Category>(
    fromFirestore: (snapshot, _) => Category.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (category, _) => category.toJson(),
  );
  Future<List<String>> getAllCategories() async {
    final docs = (await collection.get()).docs;
    List<String> data = docs.map((e) => (e.data() as Category).name!).toList();
    return data;
  }
  Stream<QuerySnapshot<Object?>> getAllCategoriesWithStream({required String filter})  {
    final searchdata = collection
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: filter +'z')
    // .orderBy('createdAt', descending: true)
        .snapshots();
    final data = collection
        .snapshots();

    return filter.isNotEmpty ? searchdata : data;
  }
  Future<void> createCategory({required String name, required Uint8List? image, required String description}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    final _category = Category( name: name, description: description, image: '', createdAt: DateTime.now());
    await collection.add(_category).then((value) async {
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
          EasyLoading.showSuccess('Create Category without image');
        }
      } else
        {
          EasyLoading.showSuccess('Create Category without image');
        }
    });

  }
  Future<void> updateCategory({required Category category, required String name, required Uint8List? image, required String description}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(category.id!).update({
      "name": name,
      "description": description,
    }).then((value) async {
      if(image != null){
        if(category.image == "" || category.image == null){
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
              await collection.doc(category.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Category without image');
          }
        } else {
          Reference referenceImageToUpload = FirebaseStorage.instance.refFromURL(category.image!);
          try {
            await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
                .whenComplete(() async {
              final _fileURL = await referenceImageToUpload
                  .getDownloadURL();
              await collection.doc(category.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Category without image');
          }
        }

      } else {
      EasyLoading.showSuccess('Create Category without image');
      }
    });

  }

  Future<void> deleteCategory({required String id}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).delete();
    EasyLoading.showSuccess(' Success!');

  }

}