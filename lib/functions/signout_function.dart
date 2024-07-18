import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signOut(BuildContext context) async {
  final googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut()
      .then((value) => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false));

}