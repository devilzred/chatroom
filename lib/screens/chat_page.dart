import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/services/chat_services/chat_services.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/custom_appbar.dart';
import 'package:chatroom/components/reuse_textformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recievedEmail;
  final String recievedID;


  ChatScreen(
      {super.key, required this.recievedEmail, required this.recievedID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  final ChatServices _chatService = ChatServices();
  FirebaseAuth _auth = FirebaseAuth.instance;

  //focus keyboard
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //add a listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //set a delay
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    //wait a bit for listview to built
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
    _messageController.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  //send message
  void sendMessage() async {
    //check if it is not empty
    if (_messageController.text.isNotEmpty) {

      // calling the function to send message from chatservices
      await _chatService.sendMessage(
          _messageController.text, widget.recievedID);

      //clear text controller
      _messageController.clear();
    }
    //scroll down when a message is send
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.recievedEmail,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(icon: Icon(Icons.block_outlined,size: 28,color: AppColors.error,),onPressed: (){
              showModalBottomSheet(context: context, builder: (context){
    return SafeArea(child: Wrap(
      children: [
      ListTile(
        leading: const Icon(Icons.question_answer_rounded),
        title: Text('Are you Sure You want to Block this Account',style: AppStyle.h2,),
      ),
      ListTile(
        leading: Icon(Icons.block),
        title: Text('Block',style: AppStyle.errorText,),
        onTap:(){

          // calling the function to block user from chatservices
          _chatService.blockUser(widget.recievedID);

          //dismiss the bottom sheet
          Navigator.pop(context);
          
          //let user know the result
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This Account is Blocked')));

          //dismiss the chat page with the user
          Navigator.pop(context);

        }
      ),
      ListTile(
        leading: const Icon(Icons.cancel),
        title: Text('Cancel',style: AppStyle.loadingText.copyWith(
          color: AppColors.primaryDark
        ),),
        onTap: (){
          Navigator.pop(context);
        },
      )
    ],
    )
    );
  });
            },),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      // calling the function to getmessage from chatservices
        stream: _chatService.getMessages(widget.recievedID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrorDialog(context, 'Something went wrong, please restart');
            return Center(child: Text('Error', style: AppStyle.errorText));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text('Loading..', style: AppStyle.loadingText));
          }
          if (snapshot.hasData) {
            print("Number of messages: ${snapshot.data!.docs.length}");
          }

          return snapshot.data!.docs.isEmpty
          //if there is no messages show the text
              ? Center(child: Text("No messages yet", style: AppStyle.h2))

              //else show the list view
              : ListView(
                  controller: _scrollController,
                  children: snapshot.data!.docs
                      .map((doc) => _buildMessageItem(doc))
                      .toList(),
                );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _auth.currentUser!.uid;

    return Align(
      //align chat messages as per user and receiver
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.text : AppColors.accent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          data["message"],
          style: AppStyle.bodyText,
        ),
      ),
    );
  }

  //message input widget
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.attach_money_outlined,
                  size: 20,
                  color: AppColors.background,
                )),
          ),
          Expanded(
              child: CustomTextFormField(
            focusNode: myFocusNode,
            hintText: 'Send Message',
            controller: _messageController,
            suffixIcon: IconButton(
                onPressed: () {
                  // calling the function to sendmessage
                  sendMessage();
                },
                icon: Icon(
                  Icons.send,
                  color: AppColors.primaryDark,
                )),
          )),
        ],
      ),
    );
  }
}
