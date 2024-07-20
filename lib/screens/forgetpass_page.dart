import 'package:chatroom/functions/vaildator_functions.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/resuse_button.dart';
import 'package:chatroom/components/reuse_textformfield.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ForgetpassPage extends StatelessWidget {
  ForgetpassPage({super.key});

  final TextEditingController _emailid = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(15.0, 120.0, 0.0, 0.0),
                  child: Text('Reset',
                      style: AppStyle.h1.copyWith(
                        color: AppColors.primary
                      ))
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 160.0, 0.0, 0.0),
                  child: Text('Password',
                      style: AppStyle.h1.copyWith(
                        color: AppColors.primaryDark
                      )),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(170.0, 160.0, 0.0, 0.0),
                  child: Text('?',
                      style: AppStyle.h1.copyWith(
                        color: AppColors.accent,
                        fontStyle: FontStyle.italic
                      )),
                ),
              ],
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 18.0, left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Enter the email address associated with your account.',
                      style: AppStyle.h2
                    ),
                    const SizedBox(height: BoxHeight.medium),
                    CustomTextFormField(
                        labelText: 'Email',
                        validator: validateEmail,
                        controller: _emailid,
                        prefixIcon: Icon(Icons.email_outlined)),
                    const SizedBox(
                      height: BoxHeight.medium,
                    ),
                    !loading
                        ? ReusableButton(
                          buttonWidth: 230,
                            buttonText: 'RESET PASSWORD',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                
                              }
                            })
                        : SizedBox(),
                      SizedBox(height: BoxHeight.small,),
                      GestureDetector(
                      child: Text("Go back & Login",style: AppStyle.link,),
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }
}