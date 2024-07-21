import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/screens/chat_page.dart';
import 'package:chatroom/services/chat_services/chat_services.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/custom_appbar.dart';
import 'package:chatroom/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivesessionPage extends StatelessWidget {
  ActivesessionPage({super.key});

  final ChatServices _chatService = ChatServices();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Active Session',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.online_prediction_outlined,
              color: AppColors.accent,
              size: 28,
            ),
          )
        ],
      ),
      body: _buildActiveUsers(context),
    );
  }

  Widget _buildActiveUsers(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getActiveUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showErrorDialog(context, 'Something went wrong, please restart');
          return Center(child: Text('Error', style: AppStyle.errorText));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading..', style: AppStyle.loadingText));
        }

        final activeUsers = snapshot.data ?? [];

        if (activeUsers.isEmpty) {
          return Center(
            child: Text('No active users', style: AppStyle.h2),
          );
        }

        return ListView.builder(
          itemCount: activeUsers.length,
          itemBuilder: (context, index) {
            final userData = activeUsers[index];
            return _buildUserListItem(userData, context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != getCurrentUser()!.email) {
      return UserTile(
        profilePicUrl: userData['profilePicUrl'] ?? '',
        text: userData['email'],
        onTap: () {
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
