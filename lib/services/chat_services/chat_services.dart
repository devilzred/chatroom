import 'package:chatroom/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
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

          // Ensure chat room document includes participants field
    await _firestore.collection('chat_rooms').doc(chatRoomID).set({
      'participants': [currentUserId, receiverID],
      'last_message': message, // Optional: to track the last message sent
      'last_message_time': timestamp // Optional: to track the time of the last message
    }, SetOptions(merge: true));

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
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('blockedusers')
            .doc(blockedUserId)
            .delete();
      } else {
        throw FirebaseAuthException(
          code: 'no-current-user',
          message: 'No current user is logged in.',
        );
      }
    } catch (e) {
      print('Error unblocking user: $e');
      throw e; // You can handle this error in the UI as needed
    }
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

  //get all the users in search
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No current user is logged in.',
      );
    }

    final allUsersSnapshot = await _firestore.collection('users').get();
    final blockedUsersSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('blockedusers')
        .get();
    final chatsSnapshot = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .get();

    List<String> blockedUserIds = blockedUsersSnapshot.docs.map((doc) => doc.id).toList();
    List<String> chatUserIds = chatsSnapshot.docs
        .map((doc) => (doc.data()['participants'] as List<dynamic>).where((id) => id != currentUser.uid).first as String)
        .toList();

    List<Map<String, dynamic>> users = [];
    for (var doc in allUsersSnapshot.docs) {
      if (doc.id != currentUser.uid && !blockedUserIds.contains(doc.id) && !chatUserIds.contains(doc.id)) {
        users.add({'id': doc.id, ...doc.data()});
      }
    }

    return users;
  }


// Get users that the current user has chatted with
  Stream<List<Map<String, dynamic>>> getUsersChattedWith() {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.error('No current user is logged in.');
    }

    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUser.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      Set<String> userIds = {};

      for (var doc in snapshot.docs) {
        var chatRoomData = doc.data();
        var participants = chatRoomData['participants'] as List<dynamic>;

        print('Chat room data: $chatRoomData');

        for (var participantId in participants) {
          if (participantId != currentUser.uid) {
            userIds.add(participantId);
          }
        }
      }

      print('User IDs: $userIds');

      List<Map<String, dynamic>> usersChattedWith = [];

      for (var userId in userIds) {
        var userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          usersChattedWith.add(userDoc.data()! as Map<String, dynamic>);
        }
      }

      print('Users chatted with: $usersChattedWith');

      return usersChattedWith;
    });
  }

}
