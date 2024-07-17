import 'package:chatroom/utils/utils.dart';
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  final double buttonHeight;
  final double buttonWidth;
  final double buttonradius;

  const ReusableButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor = AppColors.primary,
    this.buttonHeight = 40.0,
    this.buttonWidth = 170,
    this.buttonradius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
      
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonradius),
          )
        ),
        child: Text(
          buttonText,
          style: AppStyle.buttonText
        ),
      ),
    );
  }
}