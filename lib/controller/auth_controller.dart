import 'package:firebase1/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get currenceUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
}
