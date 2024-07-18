import 'package:chatroom/functions/auth_functions.dart';
import 'package:chatroom/widgets/password_form.dart';
import 'package:chatroom/functions/vaildator_functions.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/widgets/resuse_button.dart';
import 'package:chatroom/widgets/reuse_loading.dart';
import 'package:chatroom/widgets/reuse_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailcontroller = TextEditingController();

  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(image: AssetImage('assets/images/login_image.png')),
                Text(
                  "Hey Welcome Back!",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.large),
                ),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                CustomTextFormField(
                    validator: validateEmail,
                    labelText: 'Email',
                    controller: _emailcontroller,
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                    )),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                Passwordform(controller: _passwordcontroller),
                const SizedBox(
                  height: BoxHeight.verysmall,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/forgotpass');
                        },
                        child: const Text(
                          "Forget Password?",
                          style: AppStyle.link,
                        ))),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                ReusableButton(
                    buttonText: 'Login',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginWithEmailPassword(_emailcontroller.text.trim(),_passwordcontroller.text.trim(),context);
                      }
                    }),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 110,
                      child: SignInButton(
                        Buttons.Google,
                        text: "Sign-In",
                        onPressed: () {
                          continueWithGoogle(context);
                        },
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: AppFontSizes.extraLarge),
                    ),
                    GestureDetector(
                      child: Text(
                        "Create Account",
                        style: AppStyle.link,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
