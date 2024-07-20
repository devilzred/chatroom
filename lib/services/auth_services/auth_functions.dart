import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/components/reuse_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signUpWithEmailPassword(
    String email, String password, String name, String profilePicUrl,BuildContext context,) async {
  try {
    CustomLoading(context);
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).whenComplete(() {
      Navigator.of(context).pop();
    },);
      CustomLoading(context);
    // Add user information to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user?.uid)
        .set({
      'uid' : userCredential.user!.uid,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
    }).whenComplete((){
      Navigator.of(context).pop();
    });

    print('User signed up and data added to Firestore');

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route)=>false); //navigate user to homepage

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showErrorDialog(context, 'The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      showErrorDialog(context, 'The account already exists for that email.');
    } else {
      showErrorDialog(context, 'Sign up failed: ${e.message}');
      print('Sign up failed: ${e.message}');
    }
  } catch (e) {
    showErrorDialog(context, 'Error occurred: $e');
    print('Error occurred: $e');
  }
}

Future<void> loginWithEmailPassword(
    String email, String password, BuildContext context) async {
  try {
    CustomLoading(context);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).whenComplete((){
      Navigator.of(context).pop();
    });

    print('User logged in: ${userCredential.user?.email}');

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route)=>false); //navigate user to homepage

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showErrorDialog(context, 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      showErrorDialog(context, 'Wrong password provided');
      print('.');
    } else {
      print('Login failed: ${e.message}');
      showErrorDialog(context, 'Login failed: ${e.message}');
    }
  } catch (e) {
    showErrorDialog(context, 'Error occurred: $e');
    print('Error occurred: $e');
  }
}


Future<void> continueWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      showErrorDialog(context, 'Google sign in was cancelled');
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google user credentials
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if the user is new
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      // Add user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'uid' : userCredential.user!.uid,
        'name': googleUser.displayName,
        'email': googleUser.email,
      }).whenComplete(() {
    },);
    }
    print('User signed in with Google: ${userCredential.user?.email}'); //user logged successfully
 
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route)=>false); //navigate user to homepage


  } on FirebaseAuthException catch (e) {
    showErrorDialog(context, 'Google sign-in failed: ${e.message}');
    print('Google sign-in failed: ${e.message}');
  } catch (e) {
    showErrorDialog(context, 'Error occurred: $e');
    print('Error occurred: $e');
  } 
}

