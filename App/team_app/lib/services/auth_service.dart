import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Simple auth stub for development.
/// Replace with real backend calls (Firebase, REST, etc.) later.
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  User? get currentUser => _auth.currentUser;
  bool isLoggedIn = false;
  bool isLoading = true;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
        isLoggedIn = user != null;
        isLoading = false;
        notifyListeners();
        });
    }

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    notifyListeners();
    }

  Future<void> login(String email, String password) async {
  await _auth.signInWithEmailAndPassword(email: email, password: password);
  notifyListeners();

    print(FirebaseAuth.instance.currentUser);
  }

  Future<void> logout() async {
  await _auth.signOut();
  notifyListeners();
  }
}
