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
  final chatServices _chatService = chatServices();

  //function to get current user
  User? getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'H O M E',),
      drawer: MyDrawer(),
      body:_buildUserList(),
    );
  }

  //build a list of user except for the current user
  Widget _buildUserList(){
    return StreamBuilder(stream: _chatService.getunblockedUsers(), builder: (context,snapshot){

      //if error
      if(snapshot.hasError){
        showErrorDialog(context, 'Something went wrong, please restart');
        return Center(child: Text('Error',style: AppStyle.errorText,));
      }

      //loading
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: Text('Loading..',style: AppStyle.loadingText,));
      }

      //retrun list view
      return ListView(
        children: snapshot.data!.map<Widget>((userData)=>_buildUserListItem(userData,context)).toList(),
      );

    });
  }
  
  //build indivdual list tile for users
  Widget _buildUserListItem(Map<String,dynamic>userData,BuildContext context){

    //display all users except current user
    if(userData['email']!= getCurrentUser()!.email){
    return UserTile(
      text: userData['email'],
      onTap: (){
        //navigate to user chat
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(recievedEmail: userData['email'],recievedID: userData['uid'],)));
      },
    );}
    else{
      return Container();
    }
  }
}