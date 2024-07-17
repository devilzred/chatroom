import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/widgets/resuse_button.dart';
import 'package:chatroom/widgets/reuse_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(
                  image: AssetImage('assests/images/chatroom_logo.png')),
              Text(
                "Hey Welcome Back!",
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600, fontSize: AppFontSizes.large),
              ),
              const SizedBox(
                height: BoxHeight.small,
              ),
              CustomTextFormField(
                  labelText: 'Email',
                  controller: _emailcontroller,
                  prefixIcon: const Icon(
                    Icons.email_rounded,
                  )),
              const SizedBox(
                height: BoxHeight.small,
              ),
              CustomTextFormField(
                labelText: 'Password',
                controller: _passwordcontroller,
                obscureText: true,
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(onPressed: (){}, icon:Icon(Icons.visibility)),
              ),
              const SizedBox(
                height: BoxHeight.verysmall,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(child: const Text("Forget Password?",style: AppStyle.link,))),
              const SizedBox(
                height: BoxHeight.verysmall,
              ),
              ReusableButton(buttonText: 'Login', onPressed: () {}),
              const SizedBox(
                height: BoxHeight.small,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 190,
                    child: SignInButton(
                      Buttons.Google,
                      text: "Sign-In with Google",
                      onPressed: () {},
                    ),
                  ),
                  Text("|",style: TextStyle(fontSize: AppFontSizes.extraLarge),),
                  GestureDetector(
                    child: Text("Create Account",style: AppStyle.link,),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
