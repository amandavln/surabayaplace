import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _fireAuth = FirebaseAuth.instance;

class AuthProvider extends ChangeNotifier {
  final form = GlobalKey<FormState>();
  var islogin = true;

  var enteredEmail = '';
  var enteredPassword = '';
  var enteredName = ''; // ✅ TAMBAHKAN INI

  void submit(BuildContext context) async {
    final _isvalid = form.currentState!.validate();
    if (!_isvalid) return;

    form.currentState!.save();

    try {
      if (islogin) {
        await _fireAuth.signInWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
      } else {
        await _fireAuth.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );

        // (Opsional) Di sini kamu bisa menyimpan nama ke Firestore kalau mau.
      }

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      var message = 'Terjadi kesalahan. Coba lagi.';
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah.';
      } else if (e.code == 'user-not-found') {
        message = 'Akun tidak ditemukan.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    notifyListeners();
  }
}
