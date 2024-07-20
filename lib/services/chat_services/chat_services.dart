import 'package:chatroom/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatServices extends ChangeNotifier {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //instance for auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through individual user
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String message, receiverID) async {
    try {
      //get user info
      final String currentUserId = _auth.currentUser!.uid;
      final String currenUserEmail = _auth.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      //create new message
      Message newMessage = Message(
          senderID: currentUserId,
          senderEmail: currenUserEmail,
          receiverID: receiverID,
          message: message,
          timestamp: timestamp);

      //construsct a chatroom ID
      List<String> ids = [currentUserId, receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      //add new message to data
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());
      print("Message sent successfully: $message");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatRoom Id
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  //block users
  Future<void> blockUser(String userID) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedusers')
        .doc(userID)
        .set({});
    notifyListeners();
  }

  //Unblock Users
  Future<void> unblockUsers(String blockedUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('blockedusers')
        .doc(blockedUserId)
        .delete();
  }

  //Get blocked users
  Stream<List<Map<String, dynamic>>> getblockedUsers(String userID) {
    return _firestore
        .collection('users')
        .doc(userID)
        .collection('blockedusers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get list of blocked users id
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(
        blockedUserIds
            .map((id) => _firestore.collection('users').doc(id).get()),
      );
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  //getblocked user stream
  Stream<List<Map<String, dynamic>>> getunblockedUsers() {
    final currentuser = _auth.currentUser;

    return _firestore
        .collection('users')
        .doc(currentuser!.uid)
        .collection('blockedusers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get blocked users id
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

      //get all users
      final usersIds = await _firestore.collection('users').get();

      //return as stream list
      return usersIds.docs
          .where((doc) =>
              doc.data()['email'] != currentuser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }
}
