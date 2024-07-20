import 'package:chatroom/components/custom_appbar.dart';
import 'package:chatroom/components/user_tile.dart';
import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/services/chat_services/chat_services.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlockedUserList extends StatelessWidget {
  BlockedUserList({super.key});

  final ChatServices chatservices= ChatServices();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //show confirm box to unblock
  void _showUnblockBox(BuildContext context,String userID){
    showDialog(context: context
    , builder: (context)=>AlertDialog(
      title: const Text('Ublock Account'),
      content: const Text('Are you sure You want to ublock this account'),
      actions: [
        TextButton(onPressed: (){
          // calling the function to ublock user from chatservices
           chatservices.unblockUsers(userID); 

          //dismiss the diaglog
          Navigator.pop(context);

          //let user know the result
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Ublocked')));

        }, child: Text('Ublock')),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Cancel'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    
    //get current user
    String userID= auth.currentUser!.uid;
    return Scaffold(
      appBar: CustomAppBar(title: 'BLOCKED USERS'),
      body: StreamBuilder<List<Map<String,dynamic>>>(
        stream:chatservices.getblockedUsers(userID),
        builder: (context,snapshot){
          //if error
        if(snapshot.hasError){
        showErrorDialog(context, 'Something went wrong, please restart');
        return Center(child: Text('Error',style: AppStyle.errorText,));
      }

      //loading
      if(snapshot.connectionState == ConnectionState.waiting){
        return Center(child: Text('Loading..',style: AppStyle.loadingText,));
      }
      final blockedusers = snapshot.data??[];

      return blockedusers.isEmpty
              //if there is no blocked user show the text
              ? Center(child: Text("No Blocked Users", style: AppStyle.h2))

              //else show the list view of the blocked users
              :ListView.builder(itemCount: snapshot.data!.length, itemBuilder: (context,index){
                
                final user=blockedusers[index];
                return UserTile(text: user['email'], onTap: ()=>_showUnblockBox(context,user['uid']));
              });
        }, ),);
  }
}