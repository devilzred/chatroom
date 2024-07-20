import 'package:chatroom/functions/vaildator_functions.dart';
import 'package:chatroom/components/reuse_textformfield.dart';
import 'package:flutter/material.dart';

class Passwordform extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const Passwordform({
    Key? key,
    required this.controller,
    this.labelText = 'Password',
  }) : super(key: key);

  @override
  State<Passwordform> createState() => _PasswordformState();
}

class _PasswordformState extends State<Passwordform> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      validator: validatePassword,
      labelText: widget.labelText,
      controller: widget.controller,
      obscureText: _hide,
      prefixIcon: Icon(Icons.lock),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _hide = !_hide;
          });
        },
        icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}