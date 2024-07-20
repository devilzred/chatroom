import 'package:chatroom/utils/utils.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {

  final String text;
  final void Function()? onTap;
  
  const UserTile({super.key, required this.text,required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 20,
        height: 70,
        margin: EdgeInsets.fromLTRB(14, 12 ,14, 0),
        decoration: BoxDecoration(
          color: AppColors.text,
          borderRadius: BorderRadius.circular(20),
          
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
          child: Row(
            children: [
              //icon
              Icon(Icons.person),
              SizedBox(width: BoxHeight.verysmall,),
              //username
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}