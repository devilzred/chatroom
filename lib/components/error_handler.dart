
import 'package:chatroom/functions/show_error.dart';
import 'package:flutter/material.dart';

class ErrorHandler extends StatefulWidget {
  final Widget child;
  final String? errorMessage;

  const ErrorHandler({Key? key, required this.child, this.errorMessage}) : super(key: key);

  @override
  _ErrorHandlerState createState() => _ErrorHandlerState();
}

class _ErrorHandlerState extends State<ErrorHandler> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.errorMessage != null) {
        showErrorDialog(context, widget.errorMessage!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}