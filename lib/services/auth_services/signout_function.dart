import 'package:chatroom/components/reuse_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signOut(BuildContext context) async {
  CustomLoading(context);
  final googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut().whenComplete((){
    Navigator.of(context).pop();
  }).then((value) => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false));
}