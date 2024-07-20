import 'package:chatroom/components/reuse_loading.dart';
import 'package:chatroom/services/auth_services/signout_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> deleteAccount(BuildContext context, String uid, User? user,
    String email, String password) async {
  try {
    CustomLoading(context);
    if (user != null) {
      // Re-authenticate the user
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection("userData").doc(uid).delete();

      // Delete the user account from Firebase Auth
      await user.delete();

      // Sign out the user
      await signOut(context);

      // Notify the user of successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Deleted')),
      );

      // Navigate to the login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

      Navigator.pop(context);
    }
  } catch (e) {
    // Show an error message if something goes wrong
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
