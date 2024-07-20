import 'package:chatroom/services/auth_services/auth_functions.dart';
import 'package:chatroom/functions/show_error.dart';
import 'package:chatroom/components/password_form.dart';
import 'package:chatroom/functions/vaildator_functions.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/resuse_button.dart';
import 'package:chatroom/components/reuse_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _confirmpasscontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(image: AssetImage('assets/images/login_image.png')),
                Text(
                  "Let's Setup your account",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSizes.large),
                ),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                CustomTextFormField(
                    validator: validateRequired,
                    labelText: 'username',
                    controller: _namecontroller,
                    prefixIcon: const Icon(
                      Icons.emoji_people_sharp,
                    )),
                const SizedBox(
                  height: BoxHeight.verysmall,
                ),
                CustomTextFormField(
                    validator: validateEmail,
                    labelText: 'Email',
                    controller: _emailcontroller,
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                    )),
                const SizedBox(
                  height: BoxHeight.verysmall,
                ),
                Passwordform(controller: _passwordcontroller),
                const SizedBox(
                  height: BoxHeight.verysmall,
                ),
                Passwordform(controller: _confirmpasscontroller),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                ReusableButton(
                    buttonText: 'Signup',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_passwordcontroller.text.trim() == _confirmpasscontroller.text.trim()) {
                          signUpWithEmailPassword(
                              _emailcontroller.text.trim(),
                              _passwordcontroller.text.trim(),
                              _namecontroller.text,
                              context);
                        } else {
                          showErrorDialog(
                              context, "The password didn't match. Try again");
                        }
                      }
                    }),
                const SizedBox(
                  height: BoxHeight.small,
                ),
                GestureDetector(
                  child: Text(
                    "Go back & Login",
                    style: AppStyle.link,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
