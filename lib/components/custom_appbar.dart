// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:chatroom/utils/utils.dart'; // Import your app styles

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  
  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: Text(
        title,
        style: AppStyle.h2
      ),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: Colors.transparent,
      elevation: elevation,
      iconTheme: IconThemeData(color: AppColors.secondaryText),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}