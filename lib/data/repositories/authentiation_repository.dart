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

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
