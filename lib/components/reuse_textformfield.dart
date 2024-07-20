import 'package:chatroom/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? hintText;

  const CustomTextFormField({super.key, 
    this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator, 
    this.prefixIcon,
    this.suffixIcon, this.focusNode,
    this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: AppStyle.bodyText,
      decoration: InputDecoration(
        
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.border,width: 3),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary,width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
