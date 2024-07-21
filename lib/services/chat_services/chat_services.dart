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

  // Get the latest message for a chat room
  Stream<String> getLatestMessage(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['message'];
      } else {
        return '';
      }
    });
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
 
  //get Unblocked user stream 
  Stream<List<Map<String, dynamic>>> getunblockedUsers() {
  final currentUser = _auth.currentUser;

  return _firestore
      .collection('users')
      .doc(currentUser!.uid)
      .collection('blockedusers')
      .snapshots()
      .asyncMap((snapshot) async {
    // Get blocked users IDs
    final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

    // Get all users
    final usersSnapshot = await _firestore.collection('users').get();
    
    // Filter out users who are not blocked and ensure they are still valid
    return usersSnapshot.docs
        .where((doc) {
          doc.data();
          return doc.id != currentUser.uid &&
                 !blockedUserIds.contains(doc.id);
        })
        .map((doc) => doc.data())
        .toList();
  });
}

  //get active users
  Stream<List<Map<String, dynamic>>> getActiveUsers() {
  final currentUser = _auth.currentUser;

  if (currentUser == null) {
    return Stream.error('No current user is logged in.');
  }

   // Define the threshold for active users
  final int activeThresholdMinutes = 15;
  final Timestamp thresholdTimestamp = Timestamp.fromDate(
    DateTime.now().subtract(Duration(minutes: activeThresholdMinutes))
  );

  return _firestore
      .collection('users')
      .where('last_active',isGreaterThanOrEqualTo: thresholdTimestamp) // Assuming this field is set to true when the user is online
      .snapshots()
      .asyncMap((snapshot) async {
    // Get the list of blocked users
    var blockedUsersSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('blockedusers')
        .get();
    List<String> blockedUserIds = blockedUsersSnapshot.docs.map((doc) => doc.id).toList();

    // Filter out blocked users from the active users
    List<Map<String, dynamic>> activeUsers = snapshot.docs
        .map((doc) => doc.data())
        .where((user) => !blockedUserIds.contains(user['uid'])) // Filter out blocked users
        .toList();

    return activeUsers;
  });
}
}
  
  

  // //get all the users in search
  // Future<List<Map<String, dynamic>>> getAllUsers() async {
  //   final currentUser = _auth.currentUser;

  //   if (currentUser == null) {
  //     throw FirebaseAuthException(
  //       code: 'no-current-user',
  //       message: 'No current user is logged in.',
  //     );
  //   }

  //   final allUsersSnapshot = await _firestore.collection('users').get();
  //   final blockedUsersSnapshot = await _firestore
  //       .collection('users')
  //       .doc(currentUser.uid)
  //       .collection('blockedusers')
  //       .get();
  //   final chatsSnapshot = await _firestore
  //       .collection('chats')
  //       .where('participants', arrayContains: currentUser.uid)
  //       .get();

  //   List<String> blockedUserIds = blockedUsersSnapshot.docs.map((doc) => doc.id).toList();
  //   List<String> chatUserIds = chatsSnapshot.docs
  //       .map((doc) => (doc.data()['participants'] as List<dynamic>).where((id) => id != currentUser.uid).first as String)
  //       .toList();

  //   List<Map<String, dynamic>> users = [];
  //   for (var doc in allUsersSnapshot.docs) {
  //     if (doc.id != currentUser.uid && !blockedUserIds.contains(doc.id) && !chatUserIds.contains(doc.id)) {
  //       users.add({'id': doc.id, ...doc.data()});
  //     }
  //   }

  //   return users;
  // }

//get actve users


