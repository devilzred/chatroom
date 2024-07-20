// import 'package:chatroom/components/custom_appbar.dart';
// import 'package:chatroom/components/user_tile.dart';
// import 'package:chatroom/functions/show_error.dart';
// import 'package:chatroom/screens/chat_page.dart';
// import 'package:chatroom/services/chat_services/chat_services.dart';
// import 'package:chatroom/utils/utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class addChatScreen extends StatefulWidget {
//   @override
//   _addChatScreenState createState() => _addChatScreenState();
// }

// class _addChatScreenState extends State<addChatScreen> {
//   final ChatServices chatServices = ChatServices(); // Ensure this is an instance
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   List<Map<String, dynamic>> users = [];
//   List<Map<String, dynamic>> filteredUsers = [];
//   bool isLoading = true;
//   String searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   Future<void> fetchUsers() async {
//     try {
//       List<Map<String, dynamic>> allUsers = await chatServices.getAllUsers(); // Use instance to call the method
//       setState(() {
//         users = allUsers;
//         filteredUsers = allUsers;
//         isLoading = false;
//       });
//     } catch (e) {
//       showErrorDialog(context, 'Failed to fetch users.');
//     }
//   }

//   void filterUsers(String query) {
//     setState(() {
//       searchQuery = query;
//       filteredUsers = users.where((user) {
//         final emailLower = user['email'].toString().toLowerCase();
//         final queryLower = query.toLowerCase();
//         return emailLower.contains(queryLower);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Search Users'),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: 'Search by email',
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: filterUsers,
//                   ),
//                 ),
//                 Expanded(
//                   child: filteredUsers.isEmpty
//                       ? Center(child: Text('No users found', style: AppStyle.h2))
//                       : ListView.builder(
//                           itemCount: filteredUsers.length,
//                           itemBuilder: (context, index) {
//                             final user = filteredUsers[index];
//                             return UserTile(
//                               text: user['email'],
//                               onTap: () {
//                                 // Implement your logic for initiating a chat
//                                 Navigator.push(context,MaterialPageRoute(builder: (context)=> ChatScreen(recievedEmail: user['email'], recievedID: user['uid'])));
//                               },
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
