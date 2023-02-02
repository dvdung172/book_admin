import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(currentUser?.providerData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError('Wrong password provided for that user.');
      }
    }
    EasyLoading.dismiss();
  }

  Future<void> resetPassword({required String email,}) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      EasyLoading.showSuccess("email sent");
    } on FirebaseException catch (e){
      print(e);
      EasyLoading.showError("${e.message}");
    }
    EasyLoading.dismiss();
}

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    EasyLoading.dismiss();
  }

  Future<void> signOut() async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await _firebaseAuth.signOut();
    EasyLoading.dismiss();
  }
}
