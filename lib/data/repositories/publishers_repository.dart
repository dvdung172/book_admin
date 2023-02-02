import 'dart:async';
import 'dart:typed_data';

import 'package:client/data/models/publisher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:universal_io/io.dart';

class PublisherRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('NXB').withConverter<Publisher>(
    fromFirestore: (snapshot, _) => Publisher.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (publisher, _) => publisher.toJson(),
  );

  Future<List<String>> getAllPublishers() async {
    final docs = (await collection.get()).docs;
    List<String> data = docs.map((e) => (e.data() as Publisher).name!).toList();
    return data;
  }

  Stream<QuerySnapshot<Object?>> getAllPublishersWithStream({required String filter})  {
    final searchdata = collection
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: filter +'z')
        // .orderBy('createdAt', descending: true)
        .snapshots();
    final data = collection
        .snapshots();

    return filter.isNotEmpty ? searchdata : data;
  }
  Future<void> createPublisher({required String name, required Uint8List? image, required String description}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    final _publisher = Publisher( name: name, description: description, image: '', createdAt: DateTime.now());
    await collection.add(_publisher).then((value) async {
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
          EasyLoading.showSuccess('Create Publisher without image');
        }
      } else
        {
          EasyLoading.showSuccess('Create Publisher without image');
        }
    });

  }
  Future<void> updatePublisher({required Publisher publisher, required String name, required Uint8List? image, required String description}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(publisher.id!).update({
      "name": name,
      "description": description,
    }).then((value) async {
      if(image != null){
        if(publisher.image == "" || publisher.image == null){
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
              await collection.doc(publisher.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Publisher without image');
          }
        } else {
          Reference referenceImageToUpload = FirebaseStorage.instance.refFromURL(publisher.image!);
          try {
            await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
                .whenComplete(() async {
              final _fileURL = await referenceImageToUpload
                  .getDownloadURL();
              await collection.doc(publisher.id!).update({'image': _fileURL });
              EasyLoading.showSuccess(' Success!');
            });
          } catch (error) {
            EasyLoading.showSuccess('Create Publisher without image');
          }
        }

      } else {
      EasyLoading.showSuccess('Create Publisher without image');
      }
    });

  }

  Future<void> deletePublisher({required String id}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).delete();
    EasyLoading.showSuccess(' Success!');

  }

}