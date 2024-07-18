import 'package:chatroom/functions/signout_function.dart';
import 'package:chatroom/widgets/resuse_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Column(
          children: [
            ReusableButton(buttonText: "Signout", onPressed: (){
              signOut(context);
            })
          ],
        ),
      )

    );
  }
}