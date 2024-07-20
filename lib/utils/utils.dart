import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2596BE);
  static const Color primaryDark = Color(0xFF003366);
  static const Color accent = Color(0xFF50E3C2);
  static const Color background = Color(0xFFF5F5F5);
  static const Color text = Color.fromARGB(255, 235, 232, 232);
  static const Color secondaryText = Color.fromARGB(255, 21, 21, 21);
  static const Color border = Color(0xFFE0E0E0);
  static const Color error = Color(0xFFFF0000);
}

class AppFontSizes {
  static const double small = 14.0;
  static const double medium = 16.0;
   static const double lmedium = 18.0;
  static const double large = 20.0;
  static const double extraLarge = 32.0;
}
class AppStyle{
static const TextStyle h1 = TextStyle(
    fontSize: AppFontSizes.extraLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

 static const TextStyle h2 = TextStyle(
    fontSize: AppFontSizes.large,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
  );

  // Paragraphs
 static const TextStyle bodyText = TextStyle(
    fontSize: AppFontSizes.medium,
    color: AppColors.secondaryText,
    height: 1.5,
  );

 static const TextStyle bodyTextBold = TextStyle(
    fontSize: AppFontSizes.small,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryText,
    height: 1.5,
  );

  // Links
 static const TextStyle link = TextStyle(
    fontSize: AppFontSizes.small,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // Buttons
  static const TextStyle buttonText = TextStyle(
    fontSize: AppFontSizes.medium,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  // Error
  static const TextStyle errorText = TextStyle(
    fontSize: AppFontSizes.lmedium,
    fontWeight: FontWeight.normal,
    color:AppColors.error,
  );
  //loading
  static const TextStyle loadingText = TextStyle(
    fontSize: AppFontSizes.lmedium,
    fontWeight: FontWeight.normal,
    color:AppColors.accent,
  );
  
  }

class BoxHeight{
  static const double verysmall=10.0;
  static const double small=20.0;
  static const double medium=30.0;
  static const double large=40.0;
}
