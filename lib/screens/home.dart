import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/screens/chat_page.dart';
import 'package:chatroom/services/chat_services/chat_services.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/custom_appbar.dart';
import 'package:chatroom/components/my_drawer.dart';
import 'package:chatroom/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  //initialize chatservices
  final ChatServices _chatService = ChatServices();

  //function to get current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'H O M E',),
      drawer: MyDrawer(),
      // floatingActionButton: Container(
      //   width: 55,
      //   height: 55,
      //   margin: EdgeInsets.all(5.0),
      //   decoration: BoxDecoration(
      //     color: AppColors.accent,
      //     borderRadius: BorderRadius.circular(22)
      //   ),
      //   child: IconButton(onPressed: () {
      //     Navigator.pushNamed(context, '/addchat');
      //   }, icon: Icon(Icons.add_comment_rounded, color: AppColors.primaryDark, size: 30,))),
      body: _buildUsersChattedWith(),
    );
  }

  //build a list of users the current user has chatted with
  Widget _buildUsersChattedWith() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getunblockedUsers(),
      builder: (context, snapshot) {

        //if error
        if (snapshot.hasError) {
          showErrorDialog(context, 'Something went wrong, please restart');
          return Center(child: Text('Error', style: AppStyle.errorText,));
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading..', style: AppStyle.loadingText,));
        }

        //return list view
        final usersChattedWith = snapshot.data ?? [];

        if (usersChattedWith.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No recent chats', style: AppStyle.h2),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    
                    
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addchat');
                  },
                  child: Text('Start a new chat',style: AppStyle.buttonText,),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: usersChattedWith.length,
          itemBuilder: (context, index) {
            final userData = usersChattedWith[index];
            return _buildUserListItem(userData, context);
          },
        );
      },
    );
  }

  //build individual list tile for users
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          //navigate to user chat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                recievedEmail: userData['email'],
                recievedID: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
