import 'dart:convert';

import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/services/chat_services/chat_services.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/custom_appbar.dart';
import 'package:chatroom/components/reuse_textformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String recievedEmail;
  final String recievedID;

  ChatScreen({super.key, required this.recievedEmail, required this.recievedID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatService = ChatServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final FocusNode myFocusNode = FocusNode();

   Map<String, dynamic>? paymentIntent;

  // Variable to manage loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listener to scroll down when the input field is focused
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    // Initial scroll down after a slight delay
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Function to scroll down to the bottom of the list
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  // Function to send a message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(_messageController.text, widget.recievedID);
      _messageController.clear();
    }
    scrollDown();
  }

  // Widget to build the user input field and payment button
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          // Payment button
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                String amountStr = _messageController.text.trim();
                if (amountStr.isNotEmpty) {
                  int amount = int.parse(amountStr);
                  if (amount >= 50) {
                    setState(() {
                      _isLoading = true;
                    });
                    payment(amount, widget.recievedEmail).then((_) {
                      setState(() {
                        _isLoading = false;
                      });
                    }).catchError((e) {
                      setState(() {
                        _isLoading = false;
                      });
                      showErrorDialog(context, "Error during payment process: $e");
                    });
                  } else {
                    showErrorDialog(context, "Minimum Payment should be 50");
                  }
                } else {
                  showErrorDialog(context, "Please enter an amount");
                }
              },
              icon: Icon(
                Icons.attach_money_outlined,
                size: 20,
                color: AppColors.background,
              ),
            ),
          ),
          // Message input field
          Expanded(
            child: CustomTextFormField(
              focusNode: myFocusNode,
              hintText: 'Send Message',
              controller: _messageController,
              suffixIcon: IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  Icons.send,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to handle payment process
  Future<void> payment(int amount, String name) async {
    try {
      // Create payment intent body
      Map<String, dynamic> body = {
        'amount': (amount * 100).toString(), // Stripe expects the amount in cents
        'currency': 'INR',
      };

      // Send request to create payment intent
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51PedxmK8iGYfWsOyb2PlEI8O43IKpgVuCNbn6TGuZCRDpAWhpIlSTbcWJR8ftyYAtDA0pKeacJcs8M4kEyMAEJWs00r23zsdWg',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body.map((key, value) => MapEntry(key, value.toString())),
      );

      // Handle response
      if (response.statusCode == 200) {
        paymentIntent = json.decode(response.body);
        print("Payment Intent created: $paymentIntent");

        // Initialize payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.light,
            merchantDisplayName: name,
          ),
        );

        // Present payment sheet
        await Stripe.instance.presentPaymentSheet();
        print("Payment sheet presented");
      } else {
        print("Failed to create payment intent: ${response.body}");
        showErrorDialog(context, "Failed to create payment intent. Please try again.");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.recievedEmail,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              icon: Icon(
                Icons.block_outlined,
                size: 28,
                color: AppColors.error,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.question_answer_rounded),
                            title: Text(
                              'Are you Sure You want to Block this Account',
                              style: AppStyle.h2,
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.block),
                            title: Text(
                              'Block',
                              style: AppStyle.errorText,
                            ),
                            onTap: () {
                              _chatService.blockUser(widget.recievedID);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('This Account is Blocked')),
                              );
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.cancel),
                            title: Text(
                              'Cancel',
                              style: AppStyle.loadingText.copyWith(color: AppColors.primaryDark),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Message list
              Expanded(child: _buildMessageList()),
              // User input field and payment button
              _buildUserInput(),
            ],
          ),
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // Widget to build the list of messages
  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recievedID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showErrorDialog(context, 'Something went wrong, please restart');
          return Center(child: Text('Error', style: AppStyle.errorText));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading..', style: AppStyle.loadingText));
        }
        if (snapshot.hasData) {
          print("Number of messages: ${snapshot.data!.docs.length}");
        }

        return snapshot.data!.docs.isEmpty
            ? Center(child: Text("No messages yet", style: AppStyle.h2))
            : ListView(
                controller: _scrollController,
                children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
              );
      },
    );
  }

  // Widget to build each message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _auth.currentUser!.uid;

    return Align(
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
}
