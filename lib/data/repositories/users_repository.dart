import'dart:async';
import 'dart:typed_data';
import 'package:client/data/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UserRepository {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('author').withConverter<User>(
    fromFirestore: (snapshot, _) => User.fromJson(snapshot.id,snapshot.data()!),
    toFirestore: (user, _) => user.toJson(),
  );

  Future<List<String>> getAllauthors() async {
    final docs = (await collection.get()).docs;
    List<String> data = docs.map((e) => (e.data() as User).name!).toList();
    return data;
  }

  Stream<QuerySnapshot<Object?>> getAllUsersWithStream({required String filter})  {
    final searchdata = collection
        .where('name', isGreaterThanOrEqualTo: filter)
        .where('name', isLessThan: filter +'z')
    // .orderBy('createdAt', descending: true)
        .snapshots();
    final data = collection
        .snapshots();

    return filter.isNotEmpty ? searchdata : data;
  }

  // Future<void> createUser({required String name, required Uint8List? image, required String description}) async {
  //   EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
  //   final _author = User( name: name, description: description, image: '', createdAt: DateTime.now());
  //   await collection.add(_author).then((value) async {
  //     if(image != null){
  //       //image name
  //       String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  //       // storage reference
  //       Reference referenceDirImage = FirebaseStorage.instance.ref().child('images/');
  //       //upload
  //       Reference referenceImageToUpload = referenceDirImage.child(uniqueName);
  //       try {
  //         await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
  //             .whenComplete(() async {
  //           final _fileURL = await referenceImageToUpload.getDownloadURL();
  //           await collection.doc(value.id).update({'image': _fileURL });
  //           EasyLoading.showSuccess(' Success!');
  //         });
  //       } catch (error) {
  //         EasyLoading.showSuccess('Create User without image');
  //       }
  //     } else
  //       {
  //         EasyLoading.showSuccess('Create User without image');
  //       }
  //   });
  //
  // }
  // Future<void> updateUser({required User author, required String name, required Uint8List? image, required String description}) async {
  //   EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
  //   await collection.doc(author.id!).update({
  //     "name": name,
  //     "description": description,
  //   }).then((value) async {
  //     if(image != null){
  //       if(author.image == "" || author.image == null){
  //         //image name
  //         String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
  //         // storage reference2
  //         Reference referenceDirImage = FirebaseStorage.instance.ref().child('images/');
  //         //upload
  //         Reference referenceImageToUpload = referenceDirImage.child(uniqueName);
  //         try {
  //           File createFileFromBytes = File.fromRawPath(image!);
  //           await referenceImageToUpload.putFile(createFileFromBytes,SettableMetadata(contentType: 'image/png'),)
  //               .whenComplete(() async {
  //             final _fileURL = await referenceImageToUpload.getDownloadURL();
  //             await collection.doc(author.id!).update({'image': _fileURL });
  //             EasyLoading.showSuccess(' Success!');
  //           });
  //         } catch (error) {
  //           EasyLoading.showSuccess('Create User without image');
  //         }
  //       } else {
  //         Reference referenceImageToUpload = FirebaseStorage.instance.refFromURL(author.image!);
  //         try {
  //           await referenceImageToUpload.putData(image!,SettableMetadata(contentType: 'image/png'),)
  //               .whenComplete(() async {
  //             final _fileURL = await referenceImageToUpload
  //                 .getDownloadURL();
  //             await collection.doc(author.id!).update({'image': _fileURL });
  //             EasyLoading.showSuccess(' Success!');
  //           });
  //         } catch (error) {
  //           EasyLoading.showSuccess('Create User without image');
  //         }
  //       }
  //
  //     } else {
  //     EasyLoading.showSuccess('Create User without image');
  //     }
  //   });
  //
  // }

  Future<void> deleteUser({required String id}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await collection.doc(id).delete();
    EasyLoading.showSuccess(' Success!');

  }

}